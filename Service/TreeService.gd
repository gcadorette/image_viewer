class_name TreeService
var Enum = load("res://Models/Enum.gd")

func construct_tree(tree_folder: TreeFolder, tree: Tree) -> Tree:
	var root = tree.create_item()
	tree.hide_root = true
	root = construct_branch(tree, root, tree_folder)
	return tree

func construct_branch(tree: Tree, curr_branch: TreeItem, curr_folder: TreeFolder) -> TreeItem:
	for file in curr_folder.files:
		if file.type != Enum.FolderElementTypes.unknown:
			var elem = tree.create_item(curr_branch)
			elem.set_text(0, file.file_name)
			if file.type == Enum.FolderElementTypes.folder:
				elem.collapsed = true
				elem = construct_branch(tree, elem, file)
			else:
				elem.set_metadata(0, file)
	return curr_branch
