unit idewindows;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, filemanager,SynEdit,SynEditHighlighter;

type
TEditors = record
  editorID : integer;
  editorleft : TSynEdit;
  editorright : TSynEdit;
  highlighterleft : TSynCustomHighlighter;
  highlighterright : TSynCustomHighlighter;

end;

implementation

end.

