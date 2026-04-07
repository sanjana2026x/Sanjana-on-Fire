import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gas_provider.dart';
import '../widgets/status_indicator.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Clean modern background
      appBar: AppBar(
        title: const Text('Gas Safety Monitor', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<GasProvider>(
        builder: (context, provider, child) {
          final data = provider.currentData;
          final isDanger = data.isDanger;
          
          // Show dialog if danger just occurred, though local notifications handle the OS level.
          // Using a subtle approach here to not block the UI infinitely.
          
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Connection Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: provider.isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: provider.isConnected ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                        )
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            provider.isConnected ? Icons.wifi : Icons.wifi_off,
                            color: provider.isConnected ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            provider.isConnected ? 'Connected to Network' : 'Disconnected',
                            style: TextStyle(
                              color: provider.isConnected ? Colors.green[700] : Colors.red[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // Main Status Indicator
                    StatusIndicator(
                      status: data.status,
                      animate: isDanger,
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Gas Value Display
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Current Gas Level',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${data.gasValue}',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: isDanger ? Colors.redAccent : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'ppm',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<GasProvider>(context, listen: false).refreshConnection();
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Refresh Connection',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
