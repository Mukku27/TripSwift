import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_planner/apikey.dart';
import 'package:travel_planner/functions/getStringfromList.dart';
import 'package:travel_planner/responsive/responsive.dart';
import 'package:travel_planner/screens/travelPage.dart';
import 'package:travel_planner/widgets/toggleIcon.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool lightMode = false;
  String travelPrompt = '';
  String travelPlan = '';

  late DateTime _focusedDay1;
  late DateTime _focusedDay2;
  late TextEditingController destinationController;
  late FocusNode destinationFocusNode;
  late DateTime selectedDay1;
  late TextEditingController startDateController;
  late FocusNode startDateFocusNode;
  late DateTime selectedDay2;
  late TextEditingController endDateController;
  late FocusNode endDateFocusNode;
  late TextEditingController budgetController;
  late FocusNode budgetFocusNode;
  late List<String> interests;
  late List<String> selectedInterests;

  @override
  void initState() {
    _focusedDay1 = DateTime.now();
    _focusedDay2 = DateTime.now();
    destinationController = TextEditingController();
    destinationFocusNode = FocusNode();
    startDateController = TextEditingController();
    startDateFocusNode = FocusNode();
    endDateController = TextEditingController();
    endDateFocusNode = FocusNode();
    budgetController = TextEditingController();
    budgetFocusNode = FocusNode();
    selectedDay1 = DateTime.now();
    selectedDay2 = DateTime.now();
    interests = [
      'Adventure',
      'Beach',
      'Camping',
      'Cultural',
      'Food',
      'Historical',
      'Nature',
      'Relaxing',
      'Shopping',
      'Sightseeing',
      'Wildlife'
    ];
    selectedInterests = ['Camping'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF232C31),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (responsiveVisibility(context: context))
            Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFF1D2429),
              ),
            ),
          Expanded(
            flex: 8,
            child: Align(
              alignment: AlignmentDirectional(0, -1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF1D2429),
                        ),
                        child: Form(
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(4, 16, 4, 70),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (responsiveVisibility(context: context))
                                  Container(
                                    width: 400,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1D2429),
                                    ),
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Trip Planner',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ToggleIcon(
                                          onPressed: () async {
                                            setState(() {
                                              lightMode = !lightMode;
                                            });
                                          },
                                          value: lightMode,
                                          offIcon: Icon(
                                            Icons.nights_stay_sharp,
                                            color: Color(0xFFFFFFFF),
                                            size: 24,
                                          ),
                                          onIcon: Icon(
                                            Icons.lightbulb_outlined,
                                            color: Color(0xFF0B191E),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Text(
                                    'Fill out the information below in order to plan the trip',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF658593),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 16),
                                  child: TextFormField(
                                    controller: destinationController,
                                    focusNode: destinationFocusNode,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Destination',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF658593),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF293238),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF4B986C),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 24, 0, 24),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 4),
                                  child: Text(
                                    'Enter the dates for your trip',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFEEEEEE),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: Text(
                                    'Start Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                TableCalendar(
                                  focusedDay: _focusedDay1,
                                  firstDay: DateTime.utc(2020, 12, 31),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  calendarFormat: CalendarFormat.week,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  rowHeight: 64,
                                  daysOfWeekVisible: true,
                                  selectedDayPredicate: (day) {
                                    return isSameDay(selectedDay1, day);
                                  },
                                  onDaySelected: (selectedDay, focusedDay) {
                                    _focusedDay1 = focusedDay;
                                    selectedDay1 = selectedDay;
                                    startDateController.text =
                                        DateFormat('yMMMd').format(selectedDay);
                                    print(startDateController.text);
                                    setState(() {});
                                  },
                                  headerStyle: HeaderStyle(
                                    titleCentered: true,
                                    formatButtonVisible: false,
                                    titleTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left,
                                      color: Color(0xFF658593),
                                      size: 20,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF658593),
                                      size: 20,
                                    ),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    weekendStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  calendarStyle: CalendarStyle(
                                    weekendTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    defaultTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    todayTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    outsideTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                    ),
                                    selectedTextStyle: TextStyle(
                                      color: Color(0xFF658593),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Color(0xFF7CFFB2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 16),
                                  child: TextFormField(
                                    controller: startDateController,
                                    focusNode: startDateFocusNode,
                                    autofocus: true,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Start date',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF658593),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF293238),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF4b986c),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 24, 0, 24),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 0),
                                  child: Text(
                                    'End Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                TableCalendar(
                                  focusedDay: _focusedDay2,
                                  firstDay: DateTime.utc(2020, 12, 31),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  calendarFormat: CalendarFormat.week,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  rowHeight: 64,
                                  daysOfWeekVisible: true,
                                  selectedDayPredicate: (day) {
                                    return isSameDay(selectedDay2, day);
                                  },
                                  onDaySelected: (selectedDay, focusedDay) {
                                    _focusedDay2 = focusedDay;
                                    selectedDay2 = selectedDay;
                                    endDateController.text =
                                        DateFormat('yMMMd').format(selectedDay);
                                    print(endDateController.text);
                                    setState(() {});
                                  },
                                  headerStyle: HeaderStyle(
                                    titleCentered: true,
                                    formatButtonVisible: false,
                                    titleTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left,
                                      color: Color(0xFF658593),
                                      size: 20,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF658593),
                                      size: 20,
                                    ),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    weekendStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  calendarStyle: CalendarStyle(
                                    weekendTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    defaultTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    todayTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    outsideTextStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                    ),
                                    selectedTextStyle: TextStyle(
                                      color: Color(0xFF658593),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Color(0xFF7CFFB2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 16),
                                  child: TextFormField(
                                    controller: endDateController,
                                    focusNode: endDateFocusNode,
                                    autofocus: true,
                                    readOnly: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'End date',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF658593),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF293238),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF4b986c),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 24, 0, 24),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 4),
                                  child: Text(
                                    'Specify your budget(in INR) for the travel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 16),
                                  child: TextFormField(
                                    controller: budgetController,
                                    focusNode: budgetFocusNode,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: '500',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF658593),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF293238),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF4b986c),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFff5963),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 24, 0, 24),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    minLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 16, 0, 4),
                                  child: Text(
                                    'Interests/Activities',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 4, 0, 12),
                                  child: Text(
                                    'Please select all the activities you want to do',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF658593),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 8),
                                  child: Wrap(
                                    spacing: 12,
                                    children: interests.map((String option) {
                                      return FilterChip(
                                        showCheckmark: false,
                                        shape: StadiumBorder(
                                          side: BorderSide.none,
                                        ),
                                        side: BorderSide.none,
                                        label: Text(option),
                                        selected:
                                            selectedInterests.contains(option),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2, 1, 2, 1),
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          color:
                                              selectedInterests.contains(option)
                                                  ? Color(0xFFFFFFFF)
                                                  : Color(0xFF658593),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        elevation:
                                            selectedInterests.contains(option)
                                                ? 4
                                                : 0,
                                        backgroundColor: Color(0xFF293238),
                                        selectedColor: Color(0xFF4d4b986c),
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (selectedInterests
                                                .contains(option)) {
                                              selectedInterests.remove(option);
                                            } else {
                                              selectedInterests.add(option);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 24, 0, 44),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(1, 0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            isLoading = true;
                                            setState(() {});
                                            travelPrompt =
                                                'Generate a travel itinerary for a trip to ${destinationController.text}from${startDateController.text}to${endDateController.text}. The traveller has a budget of ₹${budgetController.text} and is interested in ${getStringFromList(selectedInterests.toList())}. Ensure the itinerary includes a mix of popular tourist attractions, dinning options and unique local experiences. Please provide specific details for each day. Including recommended activities, locations and dinning suggestions.';

                                            final requestBody = {
                                              'contents': [
                                                {
                                                  'parts': [
                                                    {
                                                      'text': travelPrompt,
                                                    },
                                                  ],
                                                },
                                              ],
                                              'generationConfig': {
                                                'temperature': 0.9,
                                                'topK': 1,
                                                'topP': 1,
                                                'maxOutputTokens': 16000,
                                                'stopSequences': [],
                                              },
                                              'safetySettings': [
                                                {
                                                  'category':
                                                      'HARM_CATEGORY_HARASSMENT',
                                                  'threshold':
                                                      'BLOCK_MEDIUM_AND_ABOVE',
                                                },
                                                {
                                                  'category':
                                                      'HARM_CATEGORY_HATE_SPEECH',
                                                  'threshold':
                                                      'BLOCK_MEDIUM_AND_ABOVE',
                                                },
                                                {
                                                  'category':
                                                      'HARM_CATEGORY_SEXUALLY_EXPLICIT',
                                                  'threshold':
                                                      'BLOCK_MEDIUM_AND_ABOVE',
                                                },
                                                {
                                                  'category':
                                                      'HARM_CATEGORY_DANGEROUS_CONTENT',
                                                  'threshold':
                                                      'BLOCK_MEDIUM_AND_ABOVE',
                                                },
                                              ],
                                            };
                                            final String apiKey =
                                                ApiKeys.apiKey;
                                            final String geminiModelId =
                                                'gemini-pro';
                                            final response = await http.post(
                                              Uri.parse(
                                                  'https://generativelanguage.googleapis.com/v1beta/models/$geminiModelId:generateContent?key=$apiKey'),
                                              headers: <String, String>{
                                                'Content-Type':
                                                    'application/json',
                                              },
                                              body: jsonEncode(requestBody),
                                            );
                                            if (response.statusCode == 200) {
                                              final data =
                                                  jsonDecode(response.body);
                                              print(data);
                                              final itinerary =
                                                  data['candidates'][0]
                                                          ['content']['parts']
                                                      [0]['text'];

                                              setState(() {
                                                travelPlan =
                                                    itinerary.toString();
                                              });

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return TravelPage(
                                                    destination:
                                                        destinationController
                                                            .text,
                                                    startDate:
                                                        startDateController
                                                            .text,
                                                    endDate:
                                                        endDateController.text,
                                                    budget:
                                                        budgetController.text,
                                                    travelPlan: travelPlan,
                                                  );
                                                }),
                                              );
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Something went wrong'),
                                                    content: Text(
                                                        'We were not able to generate the travel plan'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              alertDialogContext);
                                                        },
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                            isLoading = false;
                                            setState(() {});
                                          },
                                          child: isLoading
                                              ? SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                )
                                              : Text(
                                                  'Generate Travel Plan',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size.fromHeight(52),
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    32, 0, 32, 0),
                                            primary: Color(0xFF4B986C),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              side: BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (responsiveVisibility(context: context))
            Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFF1D2429),
              ),
            ),
          if (responsiveVisibility(context: context))
            CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 500),
              fadeOutDuration: Duration(milliseconds: 500),
              imageUrl:
                  'https://images.unsplash.com/photo-1585506942812-e72b29cef752?q=80&w=1928&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              width: 630,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
