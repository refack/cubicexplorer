unit CE_ToolbarButtons;

interface

uses
  // CE Units
  CE_Toolbar, CE_GlobalCtrl, CE_LanguageEngine,
  // VSTools
  MPShellUtilities, MPCommonObjects, MPCommonUtilities, EasyListview,
  // TB2K, SpTBX
  SpTBXItem, TB2Item, SpTBXSkins,
  // Tnt Controls
  TntActnList, TntClipbrd, TntSysUtils, TntClasses,
  // System Units
  Classes, Windows, SysUtils, Controls, Messages, Graphics, ImgList, ShlObj;

type
  TCEFileViewBackButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    procedure OnSubClick(Sender: TObject);
  end;


  TCEFileViewForwardButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    procedure OnSubClick(Sender: TObject);
  end;

  TCENewFileButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OnSubClick(Sender: TObject);
  end;

  TCEFileViewCopyPathButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    procedure OnSubClick(Sender: TObject);
  end;

  TCEEmptyTrashButton = class(TCEToolbarItem)
  private
    fIconIndex: Integer;
  protected
    Namespace: TNamespace;
    procedure DoDrawImage(ACanvas: TCanvas; State: TSpTBXSkinStatesType; const
        PaintStage: TSpTBXPaintStage; var AImageList: TCustomImageList; var
        AImageIndex: Integer; var ARect: TRect; var PaintDefault: Boolean);
        override;
    procedure UpdateProps; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  end;

  TCEArrangeByButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OnSubClick(Sender: TObject);
  end;

  TCEViewStyleButton = class(TCEToolbarSubmenuItem)
  protected
    procedure Populate;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCEGroupByButton = class(TCEToolbarSubmenuItem)
  protected
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OnSubClick(Sender: TObject);
  end;

type
  TCEMainMenuButton = class(TCEToolbarSubmenuItem)
  protected
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  CE_FileView, fCE_FileView, CE_BaseFileView, dCE_Actions, dCE_Images, Main;

{##############################################################################}

{*------------------------------------------------------------------------------
  Do Back Button Popup
-------------------------------------------------------------------------------}
procedure TCEFileViewBackButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  fileView: TCEFileView;
  i: Integer;
  item: TSpTBXItem;
begin
  Sender.Clear;
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    Sender.SubMenuImages:= fileView.History.SmallSysImages;
    for i:= fileView.History.ItemIndex-1 downto 0 do
    begin
      item:= TSpTBXItem.Create(Sender);
      item.Caption:= fileView.History.Items[i].NameNormal;
      item.ImageIndex:= fileView.History.Items[i].GetIconIndex(false,icSmall);
      item.Tag:= i;
      item.OnClick:= OnSubClick;
      Sender.Add(item);
    end;
  end;
end;
{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCEFileViewBackButton.OnSubClick(Sender: TObject);
var
  fileView: TCEFileView;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    if (TSpTBXItem(Sender).Tag > -1) and (TSpTBXItem(Sender).Tag < fileView.History.Count) then
    begin
      fileView.History.ItemIndex:= TSpTBXItem(Sender).Tag;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Do Forward Button Popup
-------------------------------------------------------------------------------}
procedure TCEFileViewForwardButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  fileView: TCEFileView;
  i: Integer;
  item: TSpTBXItem;
begin
  Sender.Clear;
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    Sender.SubMenuImages:= fileView.History.SmallSysImages;
    for i:= fileView.History.ItemIndex+1 to fileView.History.Count-1 do
    begin
      item:= TSpTBXItem.Create(Sender);
      item.Caption:= fileView.History.Items[i].NameNormal;
      item.ImageIndex:= fileView.History.Items[i].GetIconIndex(false,icSmall);
      item.Tag:= i;
      item.OnClick:= OnSubClick;
      Sender.Add(item);
    end;
  end;
end;
{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCEFileViewForwardButton.OnSubClick(Sender: TObject);
var
  fileView: TCEFileView;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    if (TSpTBXItem(Sender).Tag > -1) and (TSpTBXItem(Sender).Tag < fileView.History.Count) then
    begin
      fileView.History.ItemIndex:= TSpTBXItem(Sender).Tag;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCENewFileButton
-------------------------------------------------------------------------------}
constructor TCENewFileButton.Create(AOwner: TComponent);
begin
  inherited;
  Self.DropdownCombo:= false;
  Self.Options:= [tboDropdownArrow];
end;

{*------------------------------------------------------------------------------
  Do NewFile Button Popup
-------------------------------------------------------------------------------}
procedure TCENewFileButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  fileView: TCEFileView;
  i: Integer;
  item: TSpTBXItem;
begin
  Sender.Clear;
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    Sender.SubMenuImages:= SmallSysImages;
    if fileView.ShellNewMenu.Items.Count = 0 then
    fileView.ShellNewMenu.RebuildMenu;
    
    for i:= 0 to fileView.ShellNewMenu.Items.Count-1 do
    begin
      if fileView.ShellNewMenu.Items[I].Caption <> '-' then
      begin
        item:= TSpTBXItem.Create(nil);
        item.Caption:= fileView.ShellNewMenu.Items[I].Caption;
        item.Tag:= i;
        item.ImageIndex := fileView.ShellNewMenu.Items[I].ImageIndex;
        item.OnClick := OnSubClick;
        Sender.Add(item);
      end
      else
        Sender.Add(TSpTBXSeparatorItem.Create(nil));
    end;
  end;
end;

{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCENewFileButton.OnSubClick(Sender: TObject);
var
  fileView: TCEFileView;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    if (TSpTBXItem(Sender).Tag > -1) and (TSpTBXItem(Sender).Tag < fileView.ShellNewMenu.Items.Count) then
    begin
      fileView.ShellNewMenu.Items[TSpTBXItem(Sender).Tag].Click;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Do Forward Button Popup
-------------------------------------------------------------------------------}
procedure TCEFileViewCopyPathButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  item: TSpTBXItem;
  sep: TSpTBXSeparatorItem;
begin
  Sender.Clear;

  item:= TSpTBXItem.Create(Sender);
  item.Caption:= _('Folder Path');
  item.Tag:= 1;
  item.OnClick:= OnSubClick;
  Sender.Add(item);

  item:= TSpTBXItem.Create(Sender);
  item.Caption:= _('Name Only');
  item.Tag:= 2;
  item.OnClick:= OnSubClick;
  Sender.Add(item);

  sep:= TSpTBXSeparatorItem.Create(Sender);
  Sender.Add(sep);

  item:= TSpTBXItem.Create(Sender);
  item.Caption:= _('Short Path');
  item.Tag:= 3;
  item.OnClick:= OnSubClick;
  Sender.Add(item);

  item:= TSpTBXItem.Create(Sender);
  item.Caption:= _('Short Folder Path');
  item.Tag:= 4;
  item.OnClick:= OnSubClick;
  Sender.Add(item);

  item:= TSpTBXItem.Create(Sender);
  item.Caption:= _('Short Name Only');
  item.Tag:= 5;
  item.OnClick:= OnSubClick;
  Sender.Add(item);
end;

{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCEFileViewCopyPathButton.OnSubClick(Sender: TObject);
var
  fileView: TCEFileView;
  list: TTntStrings;
  i: Integer;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;
    case TComponent(Sender).Tag of
      1: TntClipboard.AsText:= IncludeTrailingBackslashW(fileView.RootFolderNamespace.NameForParsing);
      2: begin
           if fileview.Selection.Count > 1 then
           TntClipboard.AsText:= fileview.SelectedFiles.Text
           else if fileview.Selection.Count = 1 then
           TntClipboard.AsText:= fileview.SelectedFile
           else
           TntClipboard.AsText:= fileview.RootFolderNamespace.NameInFolder;
         end;
      3: begin
           if fileview.Selection.Count > 1 then
           begin
             list:= TTntStringList.Create;
             try
               list.Assign(fileview.SelectedPaths);
               for i:= 0 to list.Count - 1 do
               list.Strings[i]:= ShortPath(list.Strings[i]);
               TntClipboard.AsText:= list.Text;
             finally
               list.Free;
             end;
           end
           else if fileview.Selection.Count = 1 then
           TntClipboard.AsText:= ShortPath(fileview.SelectedPath)
           else
           TntClipboard.AsText:= ShortPath(IncludeTrailingBackslashW(fileview.RootFolderNamespace.NameForParsing));
         end;
      4: TntClipboard.AsText:= ShortPath(IncludeTrailingBackslashW(fileView.RootFolderNamespace.NameForParsing));
      5: begin
           if fileview.Selection.Count > 1 then
           begin
             list:= TTntStringList.Create;
             try
               list.Assign(fileview.SelectedPaths);
               for i:= 0 to list.Count - 1 do
               list.Strings[i]:= WideExtractFileName(ShortPath(list.Strings[i]));
               TntClipboard.AsText:= list.Text;
             finally
               list.Free;
             end;
           end
           else if fileview.Selection.Count = 1 then
           TntClipboard.AsText:= WideExtractFileName(ShortPath(fileview.SelectedPath))
           else
           TntClipboard.AsText:= WideExtractFileName(ShortPath(IncludeTrailingBackslashW(fileview.RootFolderNamespace.NameForParsing)));
         end;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEEmptyTrashButton
-------------------------------------------------------------------------------}
constructor TCEEmptyTrashButton.Create(AOwner: TComponent);
begin
  inherited;
  Namespace:= CreateSpecialNamespace(CSIDL_BITBUCKET);
  if assigned(Namespace) then
  begin
    if not Namespace.IsRecycleBin then
    FreeAndNil(Namespace);
  end;
end;

{*------------------------------------------------------------------------------
  Destroy TCEEmptyTrashButton
-------------------------------------------------------------------------------}
destructor TCEEmptyTrashButton.Destroy;
begin
  if assigned(Namespace) then
  FreeAndNil(Namespace);
  inherited;
end;

{*------------------------------------------------------------------------------
  Called on Click
-------------------------------------------------------------------------------}
procedure TCEEmptyTrashButton.Click;
begin
  inherited;
  Self.Invalidate;
end;

{*------------------------------------------------------------------------------
  Set the Icon index
-------------------------------------------------------------------------------}
procedure TCEEmptyTrashButton.DoDrawImage(ACanvas: TCanvas; State:
    TSpTBXSkinStatesType; const PaintStage: TSpTBXPaintStage; var AImageList:
    TCustomImageList; var AImageIndex: Integer; var ARect: TRect; var
    PaintDefault: Boolean);
begin
  if assigned(Namespace) then
  begin
    // TODO, might not work in all systems
    fIconIndex:= Namespace.GetIconIndex(false, icSmall);
    if fIconIndex = 31 then
    AImageIndex:= 23
    else
    AImageIndex:= 24;
  end;
  inherited;
end;

{*------------------------------------------------------------------------------
  UpdateProps
-------------------------------------------------------------------------------}
procedure TCEEmptyTrashButton.UpdateProps;
begin
  inherited;
  if assigned(Namespace) then
  begin
    if Namespace.GetIconIndex(false, icSmall) <> fIconIndex then
    //Invalidate;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEArrangeByButton
-------------------------------------------------------------------------------}
constructor TCEArrangeByButton.Create(AOwner: TComponent);
begin
  inherited;
  Self.DropdownCombo:= false;
  Self.Options:= [tboDropdownArrow];
end;

{*------------------------------------------------------------------------------
  Do ArrangeBy Button Popup
-------------------------------------------------------------------------------}
procedure TCEArrangeByButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  fileView: TCEFileView;
  item: TSpTBXItem;
  col: TEasyColumn;
begin
  Sender.Clear;
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;

    col:= fileView.Header.FirstVisibleColumn;
    while assigned(col) do
    begin
      item:= TSpTBXItem.Create(Sender);
      item.Caption:= col.Caption;
      item.OnClick:= OnSubClick;
      item.Tag:= Integer(col);
      item.RadioItem:= true;
      if col.SortDirection <> esdNone then
      item.Checked:= true;
      Sender.Add(item);
      col:= fileView.Header.NextVisibleColumn(col);
    end;
    // Separator
    Sender.Add(TSpTBXSeparatorItem.Create(Sender));
    // More... item
    item:= TSpTBXItem.Create(Sender);
    item.Caption:= _('More...');
    item.Images:= CE_Images.SmallIcons;
    item.Tag:= -1;
    item.OnClick:= OnSubClick;
    Sender.Add(item);    
  end;
end;

{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCEArrangeByButton.OnSubClick(Sender: TObject);
var
  item: TSpTBXItem;
  col, tmpCol: TEasyColumn;
  view: TCECustomFileView;
begin
  item:= TSpTBXItem(Sender);
  if item.Tag = -1 then
  begin
    if GlobalPathCtrl.ActivePage is TCEFileViewPage then
    begin
      TCEFileViewPage(GlobalPathCtrl.ActivePage).ShowHeaderSelector;
    end;
  end
  else
  begin
    col:= TEasyColumn(item.Tag);
    view:= TCECustomFileView(col.OwnerListview);
    view.BeginUpdate;
    try
      tmpCol:= view.Header.FirstColumn;
      while assigned(tmpCol) do
      begin
        if tmpCol <> col then
        tmpCol.SortDirection:= esdNone
        else
        tmpCol.SortDirection:= esdAscending;
        tmpCol:= view.Header.NextColumn(tmpCol);
      end;
    finally
      view.EndUpdate(true);
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEViewStyleButton
-------------------------------------------------------------------------------}
constructor TCEViewStyleButton.Create(AOwner: TComponent);
begin
  inherited;
  Self.DropdownCombo:= false;
  Self.Options:= [tboDropdownArrow];
  Populate;
end;

{-------------------------------------------------------------------------------
  Popuplate sub menu
-------------------------------------------------------------------------------}
procedure TCEViewStyleButton.Populate;
var
  item: TSpTBXItem;
begin
  Self.Clear;
  // Large Icons
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_large;
  Self.Add(item);
  // Small Icons
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_small;
  Self.Add(item);
  // List
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_list;
  Self.Add(item);
  // Details
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_details;
  Self.Add(item);
  // Tiles
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_tiles;
  Self.Add(item);
  // Thumbnails
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_thumbs;
  Self.Add(item);
  // Filmstrip
  item:= TSpTBXItem.Create(Self);
  item.Action:= CEActions.act_view_filmstrip;
  Self.Add(item);
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEGroupByButton
-------------------------------------------------------------------------------}
constructor TCEGroupByButton.Create(AOwner: TComponent);
begin
  inherited;
  Self.DropdownCombo:= false;
  Self.Options:= [tboDropdownArrow];
end;

{*------------------------------------------------------------------------------
  Do GroupBy Button Popup
-------------------------------------------------------------------------------}
procedure TCEGroupByButton.DoPopup(Sender: TTBCustomItem; FromLink:
    Boolean);
var
  fileView: TCEFileView;
  item: TSpTBXItem;
  col: TEasyColumn;
begin
  Sender.Clear;
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  begin
    fileView:= TCEFileViewPage(GlobalPathCtrl.ActivePage).FileView;

    // Grouped toggle item
    item:= TSpTBXItem.Create(Sender);
    item.Caption:= _('Show in Groups');
    item.Images:= CE_Images.SmallIcons;
    item.Tag:= -2;
    item.Checked:= fileView.Grouped;
    item.OnClick:= OnSubClick;
    Sender.Add(item);
    // Separator
    Sender.Add(TSpTBXSeparatorItem.Create(Sender));
    // Group By items
    col:= fileView.Header.FirstVisibleColumn;
    while assigned(col) do
    begin
      item:= TSpTBXItem.Create(Sender);
      item.Caption:= col.Caption;
      item.OnClick:= OnSubClick;
      item.Tag:= Integer(col);
      item.RadioItem:= true;
      if fileView.GroupingColumn = col.Index then
      item.Checked:= true;
      Sender.Add(item);
      col:= fileView.Header.NextVisibleColumn(col);
    end;
    // Separator
    Sender.Add(TSpTBXSeparatorItem.Create(Sender));
    // More... item
    item:= TSpTBXItem.Create(Sender);
    item.Caption:= _('More...');
    item.Images:= CE_Images.SmallIcons;
    item.Tag:= -1;
    item.OnClick:= OnSubClick;
    Sender.Add(item);    
  end;
end;

{*------------------------------------------------------------------------------
  On Submenu item Click
-------------------------------------------------------------------------------}
procedure TCEGroupByButton.OnSubClick(Sender: TObject);
var
  item: TSpTBXItem;
  col: TEasyColumn;
  page: TCEFileViewPage;
begin
  if GlobalPathCtrl.ActivePage is TCEFileViewPage then
  page:= TCEFileViewPage(GlobalPathCtrl.ActivePage)
  else
  Exit;

  item:= TSpTBXItem(Sender);
  if item.Tag = -2 then
  begin
    page.FileView.Grouped:= not page.FileView.Grouped;
  end
  else if item.Tag = -1 then
  begin
    page.ShowHeaderSelector;
  end
  else
  begin
    col:= TEasyColumn(item.Tag);
    if assigned(col) then
    begin
      page.FileView.GroupingColumn:= col.Index;
    end;
  end;
end;

{##############################################################################}

{*------------------------------------------------------------------------------
  Create an instance of TCEMainMenuButton
-------------------------------------------------------------------------------}
constructor TCEMainMenuButton.Create(AOwner: TComponent);
begin
  inherited;
  Self.DropdownCombo:= false;
  Self.Options:= [tboDropdownArrow];
  Self.LinkSubitems:= MainForm.MainToolbar.Items;
end;


end.