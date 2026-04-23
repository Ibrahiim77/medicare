import 'package:flutter/material.dart';
import 'doctorsNav.dart';
import '../appointments_provider.dart';

class DocAppointmentsPage extends StatelessWidget {
  const DocAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = AppointmentProvider.of(context).appointments;
    final updateStatus = AppointmentProvider.of(context).updateStatus;

    return DocScaffold(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appointments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (appointments.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text("No appointments yet",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: appointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appt = appointments[index];

                    Color statusColor;
                    if (appt.status == "Confirmed") {
                      statusColor = Colors.green;
                    } else if (appt.status == "Rejected") {
                      statusColor = Colors.red;
                    } else {
                      statusColor = Colors.orange;
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: statusColor.withOpacity(0.4)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  radius: 24,
                                  child: Text(
                                    appt.name[0].toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        appt.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 2),


                                      Row(
                                        children: [
                                          Icon(Icons.email_outlined,
                                              size: 12,
                                              color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            appt.email.isEmpty
                                                ? "No email"
                                                : appt.email,
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      // Date + Time
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 12,
                                              color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${appt.date.day}/${appt.date.month}/${appt.date.year}",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(Icons.access_time,
                                              size: 12,
                                              color: Colors.grey[500]),
                                          const SizedBox(width: 4),
                                          Text(
                                            appt.time.format(context),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      // Reason
                                      Text(
                                        "Reason: ${appt.reason}",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    appt.status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Confirm/Reject — sirf pending pe
                          if (appt.status == "Pending")
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () =>
                                          updateStatus(index, "Confirmed"),
                                      icon: const Icon(Icons.check,
                                          color: Colors.white, size: 16),
                                      label: const Text("Confirm",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () =>
                                          updateStatus(index, "Rejected"),
                                      icon: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                      label: const Text("Reject",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}