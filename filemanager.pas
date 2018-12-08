unit filemanager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
//file type for disk storage
Tfilerecord_file = record
  f_type  : integer;
  string1 : string[255];
  string2 : string[255];
  string3 : string[255];
  string4 : string[255];
  bool1 : boolean;
  byte1 : byte;
  byte2 : byte;
end;

Tfilerecord_project = record
  f_type  : integer;
  project_name : string[255];
  string2 : string[255];
  string3 : string[255];
  string4 : string[255];
  bool1 : boolean;
  project_type : byte;
  byte2 : byte;
end;

function getprojectname:string;
procedure closeproject;
function createnewproject(projectlocation : string;projectname : string;
                          projecttype : byte):boolean;

var
  filerecords : array of Tfilerecord_file;
  filvar : file of Tfilerecord_file;
  projectopen : boolean = false;



implementation
procedure closeproject;
begin

end;

function getprojectname:string;
var
  pProject : Tfilerecord_project;
begin
  result := '';
  if (projectopen) then
    if (length(filerecords) > 0) then
    begin
      pProject := Tfilerecord_project(filerecords[0]);
      result := pProject.project_name;
    end;
end;

function createnewproject(projectlocation : string;projectname : string;
                          projecttype : byte):boolean;
var
  projectdata : Tfilerecord_project;
begin
  assignfile(filvar,projectlocation);
  rewrite(filvar);
  setlength(filerecords,0);//clear all old file data
  setlength(filerecords,1);//create first record = project data
  projectdata.f_type := 0;//project data
  projectdata.project_name := projectname;
  projectdata.project_type:=projecttype;
  filerecords[0] := Tfilerecord_file(projectdata);
  blockwrite(filvar,filerecords,length(filerecords));
  closefile(filvar);
  projectopen := true;
end;

end.

