import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import 'package:lampsyhealth/provider/monitoringstate.dart';

import 'package:lampsyhealth/screen/screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static  final List<Widget> _widgetOptions = <Widget>[
    _DashboardView(),
    CameraScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lampsy Health',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
        Row(
          children: [
             IconButton(onPressed: (){
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                 return SingleChildScrollView(
                   child: AlertDialog(
                      title: Text('Notifications',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold
                      )),
                      backgroundColor: Colors.white,
                      content: Column(
                        children: [
                          Divider(),
                          Text('Last detected activity - 2 hours ago'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, 
                          child: Text('Close')
                        )
                      ],
                    ),
                 );
                });
            }, 
            icon: Icon(Icons.notification_important_rounded, color: Colors.redAccent)),
            IconButton(
              onPressed: () {
                bool isCameraOn = true;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) localSetState) {
                        return AlertDialog(
                          title: const Center(child: Text('Camera Settings')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                const Text('Camera'),
                                const Spacer(),
                                Text(
                                isCameraOn ? 'ON' : 'OFF',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Switch(
                                value: isCameraOn,
                                onChanged: (bool newValue) {
                                  localSetState(() {
                                    isCameraOn = newValue;
                                  });
                                },
                              ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Resolution: 1920x1080'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Camera Model: X100 V2'),
                                ],
                              ),
                        
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.camera_alt_rounded),
            ),

            IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(Icons.exit_to_app, 
                      color: Colors.black)),
          ],
        )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        onTap: _onItemTapped
        ),
    );
  }
}


class _DashboardView extends StatefulWidget {
  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {

    @override
    Widget build(BuildContext context) {

    final userEmail = FirebaseAuth.instance.currentUser?.email?? 'User';
    final today = DateTime.now();
    final formattedToday = DateFormat('dd/MM/yy').format(today);

    final yesterday = DateTime.now().subtract(Duration(days:1));
    final formattedYesterday = DateFormat('dd/MM/yy').format(yesterday);

    final monitoringState = Provider.of<MonitoringState>(context);


    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left:30, top:5, right: 30, bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), 
                  Row(
                    children: [
                      Text('Welcome',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.black,
                      )
                      ),
                      const SizedBox(width: 10),
                      Text( userEmail,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      )),
                    ],
                  ),        
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 20),
                                Text('Patient Health Overview',
                                style: Theme.of(context).textTheme.titleSmall
                                ),
                                const SizedBox(width: 10),
                                Text(formattedToday,
                                style: Theme.of(context).textTheme.titleSmall
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(
                            color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Pacient Activity', 
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white
                                    )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Last detected activity:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold)
                                    ),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('2 hours ago'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('What is this activity?',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: Text(
                                                'The "detected activity" refers to the last action recorded by the system in relation to the patient. It could be a movement, an interactive action, or any other monitored event.',
                                                textAlign: TextAlign.justify,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Duration:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('1 min 23 sec'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Understanding Total Duration',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: Text(
                                                'Total Duration refers to the cumulative time since the last detected activity. It is based on the most recent event or action recorded in relation to the patient, which could be a movement, an interaction, or any other monitored event.',
                                                textAlign: TextAlign.justify,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Last Seizure:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('1 day, 2 hours, 34 min 23 sec ago'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Last Seizure Overview',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: Text(
                                                "The Last Seizure refers to the most recent seizure detected in relation to the patient. It provides the time elapsed since the event occurred, which can be important for monitoring the patient's health and ensuring timely interventions. The duration includes the exact time that has passed since the seizure was detected.",
                                                textAlign: TextAlign.justify,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Current Status', 
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white
                                    )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Status:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold)
                                    ),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('Stable'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Patient Status',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                   Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "The Patient Status indicates the current health condition of the patient. In the context of epilepsy, this refers to whether the patient is ",
                                                        ),
                                                        TextSpan(
                                                          text: "stable",
                                                        ),
                                                        TextSpan(
                                                          text: " or experiencing any ongoing issues, such as seizures or other health concerns.'",
                                                        ),
                                                      ])),
                                                      const SizedBox(height: 10),
                                                      Text.rich(
                                                        TextSpan(
                                                        children: [
                                                        TextSpan(
                                                          text: "A ",
                                                        ),
                                                          TextSpan(
                                                          text: "Stable", 
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        TextSpan(
                                                          text: "' status means the patient is currently not showing any signs of recent seizures or alarming symptoms, while an '",
                                                        ),
                                                        TextSpan(
                                                          text: "Unstable", 
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        TextSpan(
                                                          text: "' status would indicate that the patient might be at risk or has recently experienced a seizure or other irregular activity.",
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Measurement: ', 
                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        TextSpan(
                                                          text: 'This status is determined based on continuous monitoring of the patient\'s vital signs, movements, and any detected seizures. If the system detects irregularities in the patient\'s activity, the status will reflect those changes, alerting caregivers and healthcare professionals to any issues.',
                                                        ),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.justify,
                                                  )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Weekly Average',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('5 Episodes'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Weekly Average',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: Text(
                                                'The weekly average represents the total number of episodes (seizures) detected during the past week. This is a key metric in monitoring the frequency of seizures, helping healthcare providers adjust treatment or interventions as needed.',
                                                textAlign: TextAlign.justify,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
            
                                       const SizedBox(height: 10),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Monitoring System', 
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white
                                    )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Last Alert',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold)
                                    ),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Text('2 hours ago'),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Last Alert',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('This shows the most recent alert event recorded by the system. It could include any abnormal movement detected that requires attention, whether mild, moderate, or severe.'),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Last Active Monitoring',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 5),
                                    Text(formattedYesterday), // Espacio entre los textos
                                    Text('Duration: 5 hours 23 min'),
                                    SizedBox(height: 2),
                                    Text('Started at 12:32pm ended at 5:00pm'),
          
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Last Monitoring',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: Text(
                                                'Refers to the most recent session of activity tracking or monitoring. It displays the latest status of the monitoring system, indicating whether it was active and the time it was last active.',
                                                textAlign: TextAlign.justify,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Camera Connected',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold
                                    )),
                                    SizedBox(height: 5), // Espacio entre los textos
                                    Container(
                                      width: 60,
                                      height: 40,
                                      decoration: 
                                      BoxDecoration(
                                        color: monitoringState.isMonitoringActive ? Colors.greenAccent : Colors.redAccent,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(child: Text(monitoringState.isMonitoringActive  ? 'Yes' : 'No', style: TextStyle(fontWeight: FontWeight.bold),))),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context, 
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Camera Connected',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                              )),
                                              backgroundColor: Colors.white,
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Indicates whether the camera is actively monitoring the patient or if it is in Privacy Mode.',
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                    const SizedBox(height: 10),
                                                       Text.rich(
                                                          TextSpan(
                                                          children: [
                                                          TextSpan(
                                                            text: "Active Monitoring Mode: ",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                            TextSpan(
                                                            text: "The camera is connected and actively tracking movements for potential seizure detection.", 
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                     const SizedBox(height: 10),
                                                       Text.rich(
                                                          TextSpan(
                                                          children: [
                                                          TextSpan(
                                                            text: "Privacy Mode Activated: ",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                            TextSpan(
                                                            text: "The camera is connected, but it is not actively monitoring or recording, ensuring privacy while still being available if needed.", 
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }, 
                                                  child: Text('Close')
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: Icon(Icons.info, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
            
                        ],
                      )
                      ),
                  ),
                ],
              ),
            ),
          ),
           Positioned(
            bottom: 20,
            right: 10,
            child: GestureDetector(
              onTap: (){                      
                setState(() {
                   monitoringState.toggleMonitoring();
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 190,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text( monitoringState.isMonitoringActive ? 'Monitoring Activated' : 'Privacy Mode Activated', style: TextStyle(color: Colors.white)))),
                  const SizedBox(width: 5),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon( monitoringState.isMonitoringActive ? Icons.visibility : Icons.visibility_off,
                    color: monitoringState.isMonitoringActive ? Colors.greenAccent : Colors.white,)
                  ),
                ],
              )
            )),
             Positioned(
            bottom: 80,
            right: 10,
            child: GestureDetector(
              onTap: (){                      
               showDialog(context: context, 
               builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text('An Alert Has Been Sent', style: TextStyle(fontWeight: FontWeight.bold))),
                );
               });
              },
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(90),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon( Icons.emergency,
                    color: Colors.red,
                    size: 40)
                  ),
                ],
              )
            ))
        ],
      )
    );
   }
}
