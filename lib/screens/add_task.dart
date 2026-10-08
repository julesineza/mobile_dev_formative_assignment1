import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _ink = Color(0xFF17211D);
const _muted = Color(0xFF77827D);
const _surface = Color(0xFFF0F1EB);
const _pageBackground = Color(0xFFFCFCF9);

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  String _priority = 'High';
  String _status = 'To do';
  final Set<String> _assignees = {'Mujyaneza', 'Harerimana'};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _ink),
        ),
        child: child!,
      ),
    );
    if (selected != null) setState(() => _deadline = selected);
  }

  Future<void> _selectAssignees() async {
    final selected = Set<String>.from(_assignees);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assign members',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...['Mujyaneza', 'Harerimana', 'Gashyantare', 'Hirwa'].map(
                (member) => CheckboxListTile(
                  value: selected.contains(member),
                  activeColor: _ink,
                  contentPadding: EdgeInsets.zero,
                  title: Text(member),
                  onChanged: (checked) => setSheetState(() {
                    if (checked ?? false) {
                      selected.add(member);
                    } else {
                      selected.remove(member);
                    }
                  }),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _ink,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    setState(() {
                      _assignees
                        ..clear()
                        ..addAll(selected);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) return;
    if (_assignees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assign at least one team member.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_nameController.text.trim()} created')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        elevation: 0,
        // title: const Text('New task',
        //     style: TextStyle(color: _muted, fontSize: 23)),
        // iconTheme: const IconThemeData(color: _ink),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _ink, width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _closeButton(),
                      const Expanded(
                        child: Center(
                          child: Text('New task',
                              style: TextStyle(
                                  color: _ink, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _label('TASK NAME'),
                  _textField(_nameController, 'Design notification center'),
                  const SizedBox(height: 20),
                  _label('DESCRIPTION'),
                  _textField(
                    _descriptionController,
                    'Create the primary notification list, filters, and empty state for mobile.',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _dateCard()),
                      const SizedBox(width: 10),
                      Expanded(child: _priorityCard()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('ASSIGNEES'),
                  _assigneePicker(),
                  const SizedBox(height: 20),
                  _label('STATUS'),
                  _statusPicker(),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _createTask,
                      style: FilledButton.styleFrom(
                        backgroundColor: _ink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('Create task',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _closeButton() => IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close),
        style: IconButton.styleFrom(
            backgroundColor: _surface, foregroundColor: _ink),
      );

  Widget _label(String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(value,
            style: const TextStyle(
                color: _muted, fontSize: 11, fontWeight: FontWeight.w700)),
      );

  Widget _textField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _muted, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E5DF))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E5DF))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _ink, width: 1.5)),
      ),
    );
  }

  Widget _dateCard() => _choiceCard(
        icon: Icons.calendar_today_outlined,
        label: 'Deadline',
        value: DateFormat('MMM dd, yyyy').format(_deadline),
        onTap: _selectDeadline,
      );

  Widget _priorityCard() => _choiceCard(
        icon: Icons.schedule_outlined,
        label: 'Priority',
        value: _priority,
        onTap: () async {
          final value = await _showChoice('Priority', ['Low', 'Medium', 'High']);
          if (value != null) setState(() => _priority = value);
        },
      );

  Widget _choiceCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 98,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: _muted, size: 19),
              const Spacer(),
              Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
              const SizedBox(height: 3),
              Text(value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _ink, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );

  Widget _assigneePicker() => InkWell(
        onTap: _selectAssignees,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE1E5DF)),
              borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              ..._assignees.take(3).map((member) => Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor:
                          member == 'Amina' ? const Color(0xFFA8E1C6) : const Color(0xFFFFD977),
                      child: Text(member.substring(0, 2).toUpperCase(),
                          style: const TextStyle(fontSize: 9, color: _ink)),
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _assignees.isEmpty
                      ? 'Select team members'
                      : '${_assignees.length} team members',
                  style: const TextStyle(
                      color: _ink, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: _muted),
            ],
          ),
        ),
      );

  Widget _statusPicker() => Row(
        children: ['To do', 'In progress', 'Done']
            .map(
              (status) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: SizedBox(
                        width: double.infinity,
                        child: Text(status, textAlign: TextAlign.center)),
                    selected: _status == status,
                    onSelected: (_) => setState(() => _status = status),
                    selectedColor: _ink,
                    backgroundColor: _surface,
                    labelStyle: TextStyle(
                        color: _status == status ? Colors.white : _muted,
                        fontSize: 11),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide.none),
                  ),
                ),
              ),
            )
            .toList(),
      );

  Future<String?> _showChoice(String title, List<String> options) =>
      showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              ...options.map((option) => ListTile(
                    title: Text(option),
                    onTap: () => Navigator.pop(context, option),
                  )),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
}