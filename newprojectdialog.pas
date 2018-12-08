unit newprojectdialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, filemanager;

type

  { Tnewprojectdialogwindow }

  Tnewprojectdialogwindow = class(TForm)
    newprojectnameedit: TEdit;
    Label1: TLabel;
    rb_webapplication: TRadioButton;
    rb_hybridapplication: TRadioButton;
    rb_standardapplication: TRadioButton;
    RadioGroup1: TRadioGroup;
    save1: TBitBtn;
    cancel1: TBitBtn;
    SaveDialog1: TSaveDialog;
    procedure cancel1Click(Sender: TObject);
    procedure save1Click(Sender: TObject);

  private

  public

  end;

var
  newprojectdialogwindow: Tnewprojectdialogwindow;

implementation

{$R *.lfm}

{ Tnewprojectdialogwindow }

procedure Tnewprojectdialogwindow.save1Click(Sender: TObject);
var
  projecttype : byte;
begin
  if (SaveDialog1.Execute) then
  begin
    if (rb_webapplication.Checked) then
      projecttype := 0
    else
    if (rb_hybridapplication.Checked) then
      projecttype := 1
    else
      projecttype := 2;

    filemanager.createnewproject(SaveDialog1.FileName,newprojectnameedit.Text,
                                 projecttype);
  end;
  newprojectdialogwindow.Close;
end;

procedure Tnewprojectdialogwindow.cancel1Click(Sender: TObject);
begin
  newprojectdialogwindow.Close;
end;

end.
