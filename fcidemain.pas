unit fcideMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterPython, SynHighlighterPas,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls, Buttons, StdCtrls,
  ECTabCtrl, ECSpinCtrls, ECSlider, Types,SynEditHighlighter;

type

  { TForm1 }
  TEditors = record
    editorID : integer;
    editor : TSynEdit;
    highlighter : TSynCustomHighlighter;
  end;

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    doublepane: TBitBtn;
    ECTabCtrlLeft: TECTabCtrl;
    ECTabCtrlRight: TECTabCtrl;
    idewindowleft: TPanel;
    idewindowright: TPanel;
    stepover: TBitBtn;
    settings: TBitBtn;
    run: TBitBtn;
    pause: TBitBtn;
    rewindimage: TImage;
    NewFile1: TBitBtn;
    debug: TBitBtn;
    fastforwardimage: TImage;
    mergeimage: TImage;
    splitimage: TImage;
    SaveALL: TBitBtn;
    SaveFile: TBitBtn;
    NewProject: TBitBtn;
    LoadProject: TBitBtn;
    SaveFile1: TBitBtn;
    SaveProject: TBitBtn;
    Memo1: TMemo;
    NewFile: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    FileTypeChooser: TPanel;
    idewindow: TPanel;
    projectview: TBitBtn;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    codesplitter: TSplitter;
    StatusBar2: TStatusBar;
    stepinto: TBitBtn;
    stop: TBitBtn;
    procedure doublepaneClick(Sender: TObject);
    procedure ECTabCtrl1Change(Sender: TObject);
    procedure ECTabCtrl1CloseQuery(Sender: TObject; AIndex: Integer;
      var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure NewFileClick(Sender: TObject);
    procedure projectviewClick(Sender: TObject);
  private

  public

  end;



var
  Form1: TForm1;
  Editors : array of TEditors;

const
  hPython = 0;



implementation

{$R *.lfm}
{ TForm1 }


procedure HideAllEditors;
var
  index : integer;
begin
  if length(Editors) > 0 then
  begin
    for index := 0 to length(Editors) -1 do
      Editors[index].editor.Visible := false;
  end;
end;

procedure ShowByID(editorID : integer);
var
  index : integer;
begin
  if (length(Editors) > 0) then
  begin
    for index := 0 to length(Editors) -1 do
      begin
        if (Editors[index].editorID = editorID) then
        begin
          form1.memo1.lines.add('hide');
          HideAllEditors;
          form1.memo1.lines.add('set visible');
          Editors[index].editor.Visible:=true;
          exit;
        end;
      end;
  end;

end;

function CreateNewEditor:integer;
begin
  setlength(Editors,length(Editors)+1);
  result := length(Editors) -1;
end;

procedure CreateNewIDE(pc : TWinControl; pg : TECTabCtrl; fname : string; lType : integer);
var
  tc : TECTab;
  index : integer;
begin
  //create a new tab
  tc := pg.AddTab(TECTabAdding.etaLast,true);
  //set the name of the tab to the file name
  tc.Text := fname;
  //add the capability to close and add the close button
  tc.Options := [etoCloseBtn,etoCloseable,etoVisible];
  //send the close events back up to the tabcontroller
  tc.Control := pg;
  HideAllEditors;
  index := CreateNewEditor;

  Editors[index].editorID := tc.id;
  Editors[index].editor := TSynEdit.Create(pc);
  Editors[index].editor.Parent := pc;
  Editors[index].editor.Align := alClient;
  case (lType) of
    hPython: begin
      Editors[index].highlighter := TSynPythonSyn.Create(Editors[index].editor);
      Editors[index].editor.Highlighter := Editors[index].highlighter;
    end;
  end;
end;


procedure TForm1.NewFileClick(Sender: TObject);
begin
  //CreateNewIDE(idewindow,ECTabCtrl1,'test.py',0);
end;

//deal with showing and hiding the project view
procedure TForm1.projectviewClick(Sender: TObject);
begin
  if projectview.Hint = 'Hide project view' then
    begin
      //copy the image from the hiden resource image
      projectview.Glyph := fastforwardimage.Picture.Bitmap;
      //change the button hint
      projectview.Hint := 'Show project view';
      Panel1.Visible := false; //hide project pane
      Splitter1.Visible := false; //remove splitter
    end
  else
    begin
      //copy the image from the hiden resource image
      projectview.Glyph := rewindimage.Picture.Bitmap;
      //change the button hint
      projectview.Hint := 'Hide project view';
      Splitter1.Visible := True; //add splitter
      Panel1.Visible := True; //show project pane
    end;
end;



//TODO:replace dynamic array and use TList
procedure TForm1.ECTabCtrl1CloseQuery(Sender: TObject; AIndex: Integer;
  var CanClose: Boolean);
var
  pg : TECTabCtrl;
  tc : TECTab;
  index : integer;
  newEditors : array of TEditors;
begin
  //get the page control so we can gain access to the tab
  pg := TECTabCtrl(Sender);
  //use the page contrl to access the tab
  tc := pg.Tabs.Items[AIndex];
  //loop through our array of editors to find the matching id
  //if we find the id, we delete the editor and remove it from the list
  for index := 0 to length(Editors) -1 do
    begin
      //check for matching id
      if Editors[index].editorID = tc.id then
      begin
        //destroy the editor control
        Editors[index].editor.Destroy;
      end
      else
      begin
        //these are the ones we want to keep, so we
        //copy them into a temp location
        setlength(newEditors,length(newEditors)+1);
        newEditors[length(newEditors)-1] := Editors[index];
      end;
    end;
  //now we can clear out the old list
  //and re-create it with the one deleted entry missing
  setlength(Editors,0);
  Editors := newEditors;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  codesplitter.Visible:=false;
  idewindowright.Visible:=false;
  idewindowleft.Align := alClient;
end;

procedure TForm1.ECTabCtrl1Change(Sender: TObject);
var
  index : integer;
  tc : TECTab;

begin
 // index := ECTabCtrl1.Highlighted;
 // if ((index > -1) and (ECTabCtrl1.Tabs.Count > index))then
 // begin
 //   tc := ECTabCtrl1.Tabs.Items[index];
 //   ShowByID(tc.ID);
 // end;
end;

procedure TForm1.doublepaneClick(Sender: TObject);
begin
  if doublepane.Hint = 'Split windows' then
  begin
    doublepane.Glyph := mergeimage.Picture.Bitmap;
    doublepane.Hint := 'Merge windows';
    idewindowleft.Align:=alLeft;
    codesplitter.Visible:=true;
    idewindowright.Visible:=true;
  end
  else
  begin
    doublepane.Glyph := splitimage.Picture.Bitmap;
    doublepane.Hint := 'Split windows';
    codesplitter.Visible:=false;
    idewindowright.Visible:=false;
    idewindowleft.Align := alClient;
  end;
end;



end.

