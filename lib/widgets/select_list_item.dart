import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item.dart';

class SelectListItem extends StatefulWidget {
  final Function add;
  final Function remove;

  SelectListItem(this.add, this.remove);

  @override
  _SelectListItemState createState() => _SelectListItemState();
}

class _SelectListItemState extends State<SelectListItem> {
  bool? _selected;

  @override
  void initState() {
    _selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(context);
    return Card(
      elevation: 3,
      color: Theme.of(context).primaryColor,
      child: ListTile(
        leading: Icon(Icons.dashboard_rounded,
            color: Theme.of(context).accentColor, size: 26),
        title: Text(
          "${item.name!} - (${item.type!.name!})",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          item.elapsedInstances! < 0
              ? "Never Listed"
              : "Elapsed Instances: ${item.elapsedInstances}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        ),
        trailing: IconButton(
          icon: _selected!
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
          color: Theme.of(context).accentColor,
          onPressed: () {
            setState(() {
              _selected = !_selected!;
              _selected! ? widget.add(item) : widget.remove(item);
            });
          },
        ),
      ),
    );
  }
}
