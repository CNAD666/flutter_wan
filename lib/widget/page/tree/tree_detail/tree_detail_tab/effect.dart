import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_wan/bean/home/home_article_bean.dart';
import 'package:flutter_wan/http/api.dart';
import 'package:flutter_wan/widget/page/tree/tree_detail/tree_tab_item/state.dart';

import 'action.dart';
import 'state.dart';

Effect<TreeDetailTabState> buildEffect() {
  return combineEffects(<Object, Effect<TreeDetailTabState>>{
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<TreeDetailTabState> ctx) async {
  Response response = await Dio()
      .get(ApiUrl.GET_TREE_DETAIL, queryParameters: {"cid": ctx.state.id});
  //解析的数据类型,和首页的bean结构一样
  HomeArticleBean homeArticleBean =
      HomeArticleBean().fromJson(json.decode(response.toString()));

  List<HomeArticleDataData> articleList = homeArticleBean.data.datas;
  List<TreeTabItemState> items = List();
  items = List.generate(articleList.length, (index) {
    return TreeTabItemState(itemDetail: articleList[index]);
  });

  //更新列表数据
  ctx.state.items = items;
  ctx.dispatch(TreeDetailTabActionCreator.onRefresh());
}
