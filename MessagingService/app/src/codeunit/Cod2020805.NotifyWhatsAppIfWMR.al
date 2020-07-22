codeunit 2020805 "Notify WhatsApp Interface WMR" implements "INotifyMessageInterfaceWMR"
{
    procedure CheckData(NotifyEntry: Record "Notify Entry WMR")
    begin

    end;

    procedure CheckData(NotifyEntry: Record "Notify Entry WMR"; MessageText: Text)
    begin

    end;

    procedure SendNotify(NotifyEnty: Record "Notify Entry WMR"; MessageText: Text)
    begin

    end;

    procedure SendNotify(phonenumber: text; MessageText: text)
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
        SendSMSURL: text;

    begin
        NotifyServiceSetup.Get();
        //SendSMSURL := NotifyServiceSetup."Service URL" + '/contacts/contacts/sms/' + 'Tegos' + phonenumber + '/' + template;

        InitHttpRequestContent(RequestMessage, JsonText);
        InitHttpRequestMessage(RequestMessage, SendSMSURL, 'GET');

        IsSuccessful := client.Send(RequestMessage, ResponseMessage);
        if not IsSuccessful then
            Error('Authentication failed!');

        if not ResponseMessage.IsSuccessStatusCode then begin
            Error('request was not successfully');
            exit;
        end;

        clear(TempBlob);
        TempBlob.CreateInStream(ResponseStream);

        ResponseMessage.Content.ReadAs(ResponseStream);
        ResponseJson.ReadFrom(ResponseStream);



    end;

    local procedure InitHttpRequestContent(var RequestMessage: HttpRequestMessage; JsonText: Text)
    var
        ContentHeaders: HttpHeaders;
        NotifyServiceSetup: Record "Notify Service Setup WMR";
        token: Text[100];
    begin
        NotifyServiceSetup.Get();
        token := NotifyServiceSetup."Authentication Token Key";
        RequestMessage.Content().Clear();
        RequestMessage.Content().WriteFrom(JsonText);

        RequestMessage.Content().GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Authorization', 'Bearer ' + token);
    end;

    local procedure InitHttpRequestMessage(var RequestMessage: HttpRequestMessage; ServiceURL: Text; Method: Text)
    var
        RequestHeaders: HttpHeaders;
        NotifyServiceSetup: Record "Notify Service Setup WMR";
        token: Text[100];
    begin
        token := NotifyServiceSetup."Authentication Token Key";
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Accept', 'application/json');
        RequestHeaders.Add('Authorization', 'Bearer ' + token);
        RequestMessage.Method(Method);
        RequestMessage.SetRequestUri(ServiceURL);
    end;
}