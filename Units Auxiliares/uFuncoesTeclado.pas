unit uFuncoesTeclado;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.UITypes,
  FMX.Types,
  FMX.Graphics,
  FMX.Forms,
  FMX.Controls,
  FMX.Dialogs,
  FMX.Platform,
  FMX.VirtualKeyboard;

type
  TFuncoesTeclado = Class
    private

    public
      procedure MostrarTeclado(AComponenteControl: TControl);
      procedure OcultarTeclado(AComponenteControl: TControl);
  End;

implementation

{ TFuncoesTeclado }

procedure TFuncoesTeclado.MostrarTeclado(AComponenteControl: TControl);
var
  FService : IFMXVirtualKeyboardService;
begin
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService, Iinterface(FService));
  if FService <> nil then
  begin
    FService.ShowVirtualKeyboard(AComponenteControl);
    if (AComponenteControl <> nil) and (AComponenteControl.CanFocus) then
      AComponenteControl.SetFocus;
  end;
end;

procedure TFuncoesTeclado.OcultarTeclado(AComponenteControl: TControl);
var
  FService : IFMXVirtualKeyboardService;
begin
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService, Iinterface(FService));
  if FService <> nil then
    FService.HideVirtualKeyboard;
end;

end.
