unit clsCurrentUser_u;

interface

  Uses
    Classes, SysUtils;

  type
    TCurrentUser = class(TObject)
    private
    fUID, fTID, fAID: integer;
    fUsername, fPassword: string;
    public
    Constructor Create(sUsername, sPassword: string; sUID, sTID, sAID: integer);
    procedure Login(sUsername, sPassword: string);
    function verifyLogin: boolean;
    function getUID: integer;
    function getTID: integer;
    function getAID: integer;
    function getUsername: String;
    function toString: string;
    end;

var
  sDBUsername, sDBPassword: string;

implementation

{ TCurrentUser }
//Create class
constructor TCurrentUser.Create(sUsername, sPassword: string; sUID, sTID, sAID: integer);
begin
  fUsername := sUsername;
  fPassword := sPassword;
  fUID := sUID;
  fTID := sTID;
  fAID := sAID;
end;
// return Agent ID
function TCurrentUser.getAID: integer;
begin
  Result := fAID;
end;
//return Traveller ID
function TCurrentUser.getTID: integer;
begin
  Result := fTID;
end;
//return User ID
function TCurrentUser.getUID: integer;
begin
  Result := fUID;
end;
// return username
function TCurrentUser.getUsername: String;
begin
  Result := fUsername;
end;
// setup Login process
procedure TCurrentUser.Login(sUsername, sPassword: string);
begin
  sDBUsername := sUsername;
  sDBPassword := sPassword;
end;
// convert into a string for output use
function TCurrentUser.toString: string;
begin
  Result := 'Username: '+fUsername+', UID: '+inttostr(fUID)
            +' TID: '+inttostr(fTID)+' AID: '+inttostr(fAID);
end;

// Verify if user login is correct
function TCurrentUser.verifyLogin: boolean;
begin
  if fPassword = sDBPassword then
    begin
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;

end.
