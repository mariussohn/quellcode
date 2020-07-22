enum 2020806 "Notify Interface WMR" implements "INotifyMessageInterfaceWMR"
{
    Extensible = true;

    value(0; "SMS")
    {
        Caption = 'SMS';
        Implementation = INotifyMessageInterfaceWMR = "Notify SMS Interface WMR";
    }
    value(1; "WhatsApp")
    {
        Caption = 'WhatsApp';
        Implementation = INotifyMessageInterfaceWMR = "Notify WhatsApp Interface WMR";
    }


}
