{pkgs, ...}: {
  environment.systemPackages = with pkgs.kdeApplications; [
    akonadi
    akonadi-calendar
    akonadi-contacts
    akonadi-import-wizard
    akonadi-mime
    akonadi-notes
    akonadi-search
    akonadiconsole
    akregator
    kaddressbook
    kmail
    kmail-account-wizard
    kmailtransport
    kontact
    kontactinterface
    korganizer
  ];
}
