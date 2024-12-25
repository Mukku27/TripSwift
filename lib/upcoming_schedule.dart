import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_swift/upcoming_schedule_data.dart';

class UpcomingScheduleScreen extends StatefulWidget {
  @override
  _UpcomingScheduleScreenState createState() => _UpcomingScheduleScreenState();
}

class _UpcomingScheduleScreenState extends State<UpcomingScheduleScreen> {
  // Sample events data stored locally



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Schedule"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final day = events[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  day["date"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Event List
              ...day["events"].map<Widget>((event) {
                return Dismissible(
                  key: Key(event["title"]),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Event"),
                          content: const Text("Are you sure you want to delete this event?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                    return confirmDelete ?? false;
                  },
                  onDismissed: (direction) {
                    setState(() {
                      day["events"].remove(event);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Event deleted")),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: event["color"].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: event.containsKey("icon")
                          ? Icon(event["icon"], color: event["color"])
                          : null,
                      title: Text(
                        event["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        event["time"],
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () => _showAddEventDialog(context),
      ),
    );
  }

  // Function to add a new event
  void _showAddEventDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String category = 'Personal';
    String priority = 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Event"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Title
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) => value == null || value.isEmpty ? "Title is required" : null,
                    onSaved: (value) => title = value ?? '',
                  ),
                  const SizedBox(height: 10),
                  // Date Picker
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Date"),
                    readOnly: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    },
                    validator: (value) => selectedDate == null ? "Date is required" : null,
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('EEE, dd MMM yyyy').format(selectedDate!)
                          : '',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Time Picker
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Time"),
                    readOnly: true,
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    },
                    validator: (value) => selectedTime == null ? "Time is required" : null,
                    controller: TextEditingController(
                      text: selectedTime != null
                          ? selectedTime!.format(context)
                          : '',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Category
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Category"),
                    value: category,
                    items: const [
                      DropdownMenuItem(value: "Personal", child: Text("Personal")),
                      DropdownMenuItem(value: "Office", child: Text("Office")),
                    ],
                    onChanged: (value) => category = value ?? 'Personal',
                  ),
                  const SizedBox(height: 10),
                  // Priority
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Priority"),
                    value: priority,
                    items: const [
                      DropdownMenuItem(value: "Low", child: Text("Low")),
                      DropdownMenuItem(value: "High", child: Text("High")),
                    ],
                    onChanged: (value) => priority = value ?? 'Low',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    final eventColor = (category == "Office" && priority == "High")
                        ? Colors.red
                        : Colors.green;
                    final dateKey = DateFormat('EEE, dd MMM yyyy').format(selectedDate!);
                    final existingDate = events.firstWhere(
                          (day) => day["date"] == dateKey,
                      orElse: () => {"date": dateKey, "events": []},
                    );
                    if (!events.contains(existingDate)) events.add(existingDate);
                    existingDate["events"].add({
                      "title": title,
                      "time": selectedTime!.format(context),
                      "color": eventColor,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
