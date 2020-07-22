interface "INotifyMessageInterfaceWMR"
{
    procedure CheckData(NotifyEntry: Record "Notify Entry WMR");
    procedure CheckData(NotifyEntry: Record "Notify Entry WMR"; MessageText: text);
    procedure SendNotify(NotifyEntry: Record "Notify Entry WMR"; MessageText: text);

}




