import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart'; // Correct import for authentication
import 'package:http/http.dart' as http;

class GoogleSheetsApi {
  final _scopes = [SheetsApi.spreadsheetsScope];
  late SheetsApi _sheetsApi;

  // Initialize the Google Sheets API client with the service account credentials
  Future<void> init() async {
    // Load the credentials from your JSON file
    final credentials = await rootBundle.loadString('lib/assets/cypherlock-fd08d-cbb4949dc41a.json');
    final json = jsonDecode(credentials);
    final accountCredentials = ServiceAccountCredentials.fromJson(json);
    
    // Authenticate the client with the correct scopes
    final authClient = await clientViaServiceAccount(accountCredentials, _scopes);
    _sheetsApi = SheetsApi(authClient);
  }

  // Fetch data from the Google Sheet for a specific range (A:D or others)
  Future<List<List<dynamic>>> getSpreadsheetData(String spreadsheetId, String range) async {
    final response = await _sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    return response.values ?? [];  // Return the data or an empty list if no values found
  }

  // Add a new member to the Google Sheet
  Future<void> addMember(String spreadsheetId, List<dynamic> memberData) async {
    // Fetch existing members from column A (to calculate the next serial number)
    final data = await getSpreadsheetData(spreadsheetId, 'CypherLock Club!A:A');
    
    // Find the last serial number in column A and increment it for the new member
    int lastSerialNumber = 0;
    if (data.isNotEmpty) {
      lastSerialNumber = int.tryParse(data.last.first.toString()) ?? 0;  // Parse the last serial number
    }
    int nextSerialNumber = lastSerialNumber + 1;

    // Prepare the member data with the serial number in Column A, name in Column B, UID in Column C
    List<dynamic> formattedMemberData = [nextSerialNumber, memberData[0], memberData[1], memberData[2]]; // Include Member ID in Column D

    // Create a value range to append the data
    ValueRange valueRange = ValueRange.fromJson({
      "values": [formattedMemberData],
    });

    // Append the member data to the Google Sheet (A:D range)
    await _sheetsApi.spreadsheets.values.append(
      valueRange,
      spreadsheetId,
      'CypherLock Club!A:D', // Corrected the typo in the range (A:D)
      valueInputOption: 'RAW',
    );
  }

  // Delete a member's row from the Google Sheet
  Future<void> deleteMember(String spreadsheetId, int rowIndex) async {
    // Specify the range for the row you want to delete
    String range = 'CypherLock Club!A$rowIndex:D$rowIndex';
    
    // Clear the values in the specified row
    await _sheetsApi.spreadsheets.values.clear(
      ClearValuesRequest(),
      spreadsheetId,
      range,
    );
  }
}
