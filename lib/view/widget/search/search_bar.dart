import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wan/app/utils/ui/ui_adapter.dart';
import 'package:flutter_wan/view/widget/input/input_actions.dart';

///此控件已减少相关依赖
///此控件进行少量导包修改即可移植其它项目使用
typedef SearchParamSingleCallback<D> = dynamic Function(D data);

class SearchBar extends StatefulWidget {
  SearchBar({
    this.inputFormatters,
    this.hintText = '请输入',
    this.hintColor = const Color(0xFFCCCCCC),
    this.textColor = const Color(0xFF333333),
    this.keyboardType,
    this.autofocus,
    this.onChanged,
    this.iconColor = const Color(0xFFCCCCCC),
    this.onComplete,
    this.controller,
  });

  ///限制输入条件
  final List<TextInputFormatter> inputFormatters;

  ///提示文字和样式颜色
  final String hintText;
  final Color hintColor;

  ///显示文字颜色
  final Color textColor;

  ///唤起不同的键盘类型
  final TextInputType keyboardType;

  ///是否自动聚焦焦点
  final bool autofocus;

  ///icon颜色
  final Color iconColor;

  ///回调输入的数据
  final SearchParamSingleCallback<String> onChanged;

  ///输入完成  点击键盘上: 收缩,Ok等按钮
  final SearchParamSingleCallback<String> onComplete;

  ///输入框控制器
  final TextEditingController controller;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  FocusNode focusNode;
  TextEditingController controller;

  ///动画
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    controller = widget.controller ?? TextEditingController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchBody();
  }

  Widget _buildSearchBody() {
    return _searchBg(
      child: Row(
        children: [
          //搜索icon
          _buildSearchIcon(),

          //输入框
          buildSearchInput(),

          //删除图标
          Expanded(
            child: buildSearchDelete(),
          )
        ],
      ),
    );
  }

  Widget buildSearchDelete() {
    return Container(
      margin: EdgeInsets.only(right: auto(18)),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          //处理下删除逻辑
          animationController.reverse();
          controller.clear();
          widget.onChanged(controller.text);
        },
        child: ScaleTransition(
          scale: animation,
          child: Container(
            padding: EdgeInsets.all(auto(10)),
            child: Icon(
              CupertinoIcons.clear_circled_solid,
              size: auto(38),
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchInput() {
    return Container(
      width: auto(500),
      padding: EdgeInsets.only(left: auto(24)),
      child: InputActions(
        context: context,
        focusNode: focusNode,
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus ?? false,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: widget.textColor,
            fontSize: setSp(28),
          ),
          inputFormatters: widget.inputFormatters,
          maxLengthEnforced: true,
          decoration: InputDecoration(
            ///较小空间时，使组件正常渲染，包括文本垂直居中
            isDense: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.hintColor,
              fontSize: setSp(24),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(0.0),
          ),
          onChanged: (msg) {
            //处理下删除图标的显示
            if (msg.length != 0) {
              animationController.forward();
            } else {
              animationController.reverse();
            }

            //监听输入的数值
            widget.onChanged(msg);
          },
          onEditingComplete: () {
            widget.onComplete(controller.text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      margin: EdgeInsets.only(left: auto(29)),
      child: Icon(Icons.search, color: widget.iconColor),
    );
  }

  ///主体背景构造
  Widget _searchBg({Widget child}) {
    return Container(
      height: auto(72),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
