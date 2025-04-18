import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';

import '../../apis/models/note.dart';
import '../mk_refresh_load.dart';
import 'note_card.dart';

class MkPaginationNoteList extends HookConsumerWidget {
  const MkPaginationNoteList({
    super.key,
    required this.onLoad,
    required this.onRefresh,
    this.slivers,
    this.padding = EdgeInsets.zero,
    required this.hasMore,
    this.items,
    this.controller,
  });

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget>? slivers;
  final bool? hasMore;

  final List<NoteModel>? items;
  final MkRefreshLoadListController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding =
            EdgeInsets.symmetric(horizontal: getPaddingForNote(constraints))
                .add(this.padding);
        return MkRefreshLoadList<NoteModel>(
          onLoad: onLoad,
          onRefresh: onRefresh,
          padding: padding,
          controller: controller,
          slivers: [
            ...?slivers,
            SliverList.separated(
              itemBuilder: (BuildContext context, int index) {
                BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
                if (index == 0) {
                  borderRadius = borderRadius.copyWith(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  );
                }
                if (index + 1 == items?.length) {
                  borderRadius = borderRadius.copyWith(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  );
                }
                return RepaintBoundary(
                  child: NoteCard(
                      key: ValueKey(items![index].id),
                      borderRadius: borderRadius,
                      data: items![index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: double.infinity,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: themes.dividerColor,
                    ),
                  ),
                );
              },
              itemCount: items?.length ?? 0,
            )
          ],
          hasMore: hasMore,
          empty: items?.isEmpty,
        );
      },
    );
  }
}
