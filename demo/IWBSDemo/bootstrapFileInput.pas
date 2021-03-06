unit bootstrapFileInput;

interface

uses
  IWAppForm, Classes, Controls, System.StrUtils, System.SysUtils, Math,
  IWCompExtCtrls, IWDBExtCtrls, IWDBStdCtrls, IWDBGrids, IWCompGrids,
  IWCompEdit, IWCompLabel, IWControl, IWCompMemo, IWBaseControl, DBClient,
  DB, Forms, IWContainer, IWRegion, IWVCLBaseControl, IWVCLBaseContainer,
  IWBaseHTMLControl, IWHTMLContainer, IWHTML40Container, IWCompButton,
  IWBSRegion, IWBSInput, IWVCLComponent, IWBaseLayoutComponent,
  IWBaseContainerLayout, IWContainerLayout, IWBSLayoutMgr, IWBSControls,
  Vcl.Graphics, IWCompCheckbox, IWCompListbox, IWCompText, IWHTMLControls,
  MidasLib, IWBSCustomInput, IWBSButton, IWBSCustomControl, IWBSImage,
  IWCompTabControl, IWBSTabControl,
  IW.HTTP.Request, IW.HTTP.Reply, IWApplication, IWBSNavBar;

type
  TFBootstrapFileInput = class(TIWAppForm)
    IWBSRegion1: TIWBSRegion;
    IWBSRegion2: TIWBSRegion;
    IWBSRegion3: TIWBSRegion;
    IWBSLayoutMgr1: TIWBSLayoutMgr;
    IWText1: TIWBSText;
    IWBSRegion8: TIWBSNavBar;
    IWBSButton1: TIWBSButton;
    IWBSRegion4: TIWBSRegion;
    IWBSInput1: TIWBSFile;
    IWBSRegion5: TIWBSRegion;
    procedure IWFormModuleBaseCreate(Sender: TObject);
    procedure IWBSButton1AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWBSInput1CustomAsyncEvents0AsyncEvent(Sender: TObject;
      EventParams: TStringList);
    procedure IWBSInput1CustomRestEvents0RestEvent(aApplication: TIWApplication;
      aRequest: THttpRequest; aReply: THttpReply; aParams: TStrings);
  end;

implementation
{$R *.dfm}

uses IWBSRestServer, IW.HTTP.FileItem, jpeg;

procedure TFBootstrapFileInput.IWBSButton1AsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  Release;
end;

procedure TFBootstrapFileInput.IWBSInput1CustomAsyncEvents0AsyncEvent(Sender: TObject; EventParams: TStringList);
begin
  IWBSRegion5.AsyncRefreshControl;
end;

procedure TFBootstrapFileInput.IWBSInput1CustomRestEvents0RestEvent(
  aApplication: TIWApplication; aRequest: THttpRequest; aReply: THttpReply;
  aParams: TStrings);
var
  AStream: TMemoryStream;
  J: TJPEGImage;
  i: integer;
begin
  // read de file and dinamically creates a TIWBSImage
  for i := 0 to aRequest.Files.Count-1 do begin
    AStream := TStringStream.Create;
    try
      THttpFile(aRequest.Files[i]).SaveToStream(AStream);
      AStream.Position := 0;
      with TIWBSImage.Create(Self) do begin
        Parent := IWBSRegion5;
        j := TJPEGImage.Create;
        try
          j.LoadFromStream(AStream);
          Picture.Assign(j);
        finally
          j.Free;
        end;
      end;
    finally
      AStream.Free;
    end;
  end;
  aReply.WriteString('{"id": "1"}');
end;

procedure TFBootstrapFileInput.IWFormModuleBaseCreate(Sender: TObject);
begin
  // include third party plugin
  IWBSLayoutMgr1.AddLinkFile('https://cdnjs.cloudflare.com/ajax/libs/bootstrap-fileinput/4.3.2/css/fileinput.min.css');
  IWBSLayoutMgr1.AddLinkFile('https://cdnjs.cloudflare.com/ajax/libs/bootstrap-fileinput/4.3.2/js/fileinput.min.js');
end;

initialization
  // this enable the rest event server
  IWBSRegisterRestServerHandler;

end.
