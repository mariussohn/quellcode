codeunit 2020800 "Notify Service Setup WMR"
{
    var
        SendingHttpRequestFailedErr: Label 'Http Request failed. Please update your credentials.';
        BadRequestErr: Label 'Error code: %1. Failed to query the web service. Please contact the provider.', Comment = '%1 = StatusCode';
        UnauthorizedErr: Label 'Error code: %1. You do not have permission to use this function. Please contact the provider.', Comment = '%1 = StatusCode';
        ForbiddenErr: Label 'Error code: %1. Please check that the credentials and the service url are correct.', Comment = '%1 = StatusCode';
        NotFoundErr: Label 'Error code: %1. Web service not found. Please check the service url..', Comment = '%1 = StatusCode';
        InternalServerErr: Label 'Error code: %1. The server does not respond. Please try again later.', Comment = '%1 = StatusCode';
        UnknownErr: Label 'Error code: %1. Unknown Error. Please contact the provider.', Comment = '%1 = StatusCode';

    procedure sendPostRequest()
    var
        client: HttpClient;
        RequestMessage: HttpRequestMessage;
        RequestHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        NotifyServiceSetup: Record "Notify Service Setup WMR";
        JsonText: Text;
        IsSuccessful: Boolean;
        ResponseStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        ResponseJson: JsonObject;
        RequestJson: JsonObject;
        jwt: text;
        AuthenticateURL: text;
        StatusCode: Integer;
    begin
        NotifyServiceSetup.Get();
        AuthenticateURL := NotifyServiceSetup."Service URL" + '/authenticate';
        JsonText := BuildAuthReqContent(NotifyServiceSetup.Username, NotifyServiceSetup.GetPassword(NotifyServiceSetup."Password Key"));
        InitHttpRequestContent(RequestMessage, JsonText);
        InitHttpRequestMessage(RequestMessage, AuthenticateURL, 'POST');
        IsSuccessful := client.Send(RequestMessage, ResponseMessage);
        if not IsSuccessful then
            Error(SendingHttpRequestFailedErr);
        if not ResponseMessage.IsSuccessStatusCode then begin
            StatusCode := ResponseMessage.HttpStatusCode;
            case StatusCode of
                400:
                    Error(BadRequestErr, StatusCode);
                401:
                    Error(UnauthorizedErr, StatusCode);
                403:
                    Error(ForbiddenErr, StatusCode);
                404:
                    Error(NotFoundErr, StatusCode);
                500:
                    Error(InternalServerErr, StatusCode);
                502:
                    Error(InternalServerErr, StatusCode);
                504:
                    Error(InternalServerErr, StatusCode);
                else
                    Error(UnknownErr, Statuscode);
            end;
        end;

        clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);
        ResponseMessage.Content.ReadAs(ResponseStream);
        ResponseJson.ReadFrom(ResponseStream);
        GetPropertyFromJsonObject(ResponseJson, 'jwt', jwt);
        NotifyServiceSetup.SavePassword(NotifyServiceSetup."Authentication Token Key", jwt);
    end;

    local procedure GetPropertyFromJsonObject(var JsonObject: JsonObject; PropertyName: Text; var PropertyValue: Text)
    var
        ValueToken: JsonToken;
        Value: JsonValue;
    begin
        if JsonObject.Get(PropertyName, ValueToken) then
            if ValueToken.IsValue then begin
                Value := ValueToken.AsValue();
                If not (Value.IsNull or Value.IsUndefined) then
                    PropertyValue := Value.AsText();
            end;
    end;

    local procedure BuildAuthReqContent(Username: Text[50]; Password: Text[250]) ContentText: Text
    var
        ContentJson: JsonObject;
    begin
        ContentJson.Add('username', Username);
        ContentJson.Add('password', Password);
        ContentJson.WriteTo(ContentText);
    end;

    local procedure InitHttpRequestContent(var RequestMessage: HttpRequestMessage; JsonText: Text)
    var
        ContentHeaders: HttpHeaders;
    begin
        RequestMessage.Content().Clear();
        RequestMessage.Content().WriteFrom(JsonText);

        RequestMessage.Content().GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json')
    end;

    local procedure InitHttpRequestMessage(var RequestMessage: HttpRequestMessage; ServiceURL: Text; Method: Text)
    var
        RequestHeaders: HttpHeaders;
    begin
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Accept', 'application/json');
        RequestMessage.Method(Method);
        RequestMessage.SetRequestUri(ServiceURL);
    end;
}