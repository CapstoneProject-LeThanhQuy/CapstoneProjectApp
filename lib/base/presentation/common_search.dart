import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/common_edit_text.dart';

class SearchCommon extends StatelessWidget {
  final Function(String)? onChange;
  final Function()? onSaved;
  final bool autofocus;

  const SearchCommon({
    Key? key,
    this.onChange,
    this.onSaved,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: 48.0,
      child: CommonEditText(
        onSaved: onSaved,
        autofocus: autofocus,
        hintText: 'Tìm kiếm',
        prefixIcon: const Icon(Icons.search),
        onChange: onChange,
      ),
    );
  }
}
