import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan/bean/tree/tree_info_bean.dart';

class TreeDetailState implements Cloneable<TreeDetailState> {
  //数据
  TreeInfoData treeInfoData;

  //顶部tab数据
  List<Tab> topList;

  @override
  TreeDetailState clone() {
    // TODO: implement clone
    return TreeDetailState()
        ..treeInfoData = treeInfoData
        ..topList = topList;
  }
}

TreeDetailState initState(Map<String, dynamic> args) {
  TreeInfoData tempTreeInfo = args["treeDetail"];

  //设置顶部tab
  List<Tab> tabs = List();
  for(int i=0; i<tempTreeInfo.children.length; i++){
    var child = tempTreeInfo.children[i];
    tabs.add(Tab(text: child.name));
  }
  return TreeDetailState()
      ..topList = tabs;
}
