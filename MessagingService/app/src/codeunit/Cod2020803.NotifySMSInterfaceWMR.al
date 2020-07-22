codeunit 2020803 "Notify SMS Interface WMR" implements "INotifyMessageInterfaceWMR"
{
    var
        MessageTextEmptyErr: Label 'You must specify a message.';
        MessageTextExceedsMaxLengthErr: Label 'The message must not have more than %1 characters.\Message: %2\Length: %3',
        Comment = '%1 = Max length; %2 = Current message text; %3 = Length of current message text';
        ContactDoesNotExistsErr: Label 'Unable to process Notify Entry, Entry No. = %1, because Contact ''%2'' does not exists.',
        Comment = '%1 = Notify Entry No., %2 = Contact No.';
        MissingMobilePhoneNumberErr: Label 'Unable to process Notify Entry, Entry No. = %1, because No Mobile Phone Number does exist. Please insert a mobile phone number into the contact %2',
        Comment = '%1 = Notify Entry No.; %2 = Contact No. ';
        SendingHttpRequestFailedErr: Label 'Http Request failed. Please update your credentials.';
        BadRequestErr: Label 'Error code: %1. Failed to query the web service. Please contact the provider.', Comment = '%1 = StatusCode';
        UnauthorizedErr: Label 'Error code: %1. You do not have permission to use this function. Please contact the provider.', Comment = '%1 = StatusCode';
        ForbiddenErr: Label 'Error code: %1. Please check that the credentials and the service url are correct.', Comment = '%1 = StatusCode';
        NotFoundErr: Label 'Error code: %1. Web service not found. Please check the service url..', Comment = '%1 = StatusCode';
        InternalServerErr: Label 'Error code: %1. The server does not respond. Please try again later.', Comment = '%1 = StatusCode';
        UnknownErr: Label 'Error code: %1. Unknown Error. Please contact the provider.', Comment = '%1 = StatusCode';

    procedure CheckData(NotifyEntry: Record "Notify Entry WMR")
    begin
        ErrorIfContactNotExists(NotifyEntry);
        ErrorIfMobilePhoneNoIsNotFilled(NotifyEntry);
    end;

    procedure CheckData(NotifyEntry: Record "Notify Entry WMR"; MessageText: text)
    begin
        ErrorIfMessageTextIsEmpty(MessageText);
        ErrorIfMessageTextExceedsMaxLength(MessageText);

        ErrorIfContactNotExists(NotifyEntry);
        ErrorIfMobilePhoneNoIsNotFilled(NotifyEntry);
    end;

    procedure SendNotify(NotifyEntry: Record "Notify Entry WMR"; MessageText: Text)
    var
        Cont: Record Contact;
    begin
        CheckData(NotifyEntry, MessageText);

        Cont.Get(NotifyEntry."Contact No.");
        SendNotify(Cont."Mobile Phone No.", MessageText);
    end;

    procedure SendNotify(PhoneNumber: text; MessageText: text)
    var
        notifyServiceSetup: Record "Notify Service Setup WMR";
        content: HttpContent;
        contentHeaders: HttpHeaders;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        Url: Text;
        token: Text[250];
    begin
        NotifyServiceSetup.Get();
        token := NotifyServiceSetup.GetToken(NotifyServiceSetup."Authentication Token Key");
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        request.GetHeaders(contentHeaders);
        contentHeaders.Add('Authorization', StrSubstNo('Bearer %1', token));
        contentHeaders.Add('Accept', 'application/json');
        Url := NotifyServiceSetup."Service URL" + '/contacts/contacts/sms/' + 'Tegos/' + PhoneNumber + '/' + MessageText;
        request.SetRequestUri(Url);
        request.Method := 'GET';
        CheckAndSendNotify(response, request);
    end;

    local procedure CheckAndSendNotify(response: HttpResponseMessage; request: HttpRequestMessage)
    var
        IsSuccessful: Boolean;
        client: HttpClient;
        StatusCode: Integer;
    begin
        IsSuccessful := client.Send(request, response);
        if not IsSuccessful then
            Error(SendingHttpRequestFailedErr);
        if not response.IsSuccessStatusCode then begin
            StatusCode := response.HttpStatusCode;
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
    end;

    local procedure ErrorIfMessageTextIsEmpty(MessageText: Text)
    begin
        If MessageText = '' then
            Error(MessageTextEmptyErr);
    end;

    local procedure ErrorIfMessageTextExceedsMaxLength(MessageText: Text)
    begin
        if StrLen(MessageText) > MaxMessageLength then
            Error(MessageTextExceedsMaxLengthErr, MaxMessageLength, MessageText, StrLen(MessageText));
    end;

    local procedure ErrorIfContactNotExists(NotifyEntry: Record "Notify Entry WMR")
    var
        Cont: Record Contact;
    begin
        NotifyEntry.TestField("Contact No.");
        if not Cont.Get(NotifyEntry."Contact No.") then
            Error(ContactDoesNotExistsErr, NotifyEntry."Entry No.", NotifyEntry."Contact No.");
    end;

    local procedure ErrorIfMobilePhoneNoIsNotFilled(NotifyEntry: Record "Notify Entry WMR")
    var
        Cont: Record Contact;
    begin
        Cont.Get(NotifyEntry."Contact No.");
        if Cont."Mobile Phone No." = '' then
            Error(MissingMobilePhoneNumberErr, NotifyEntry."Entry No.", NotifyEntry."Contact No.");
    end;

    procedure MaxMessageLength(): Integer
    begin
        exit(160);
    end;
}

