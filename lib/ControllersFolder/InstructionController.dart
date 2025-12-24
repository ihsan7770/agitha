import 'package:agitha/ModelsFoder/InstructionModel.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/Addinstructions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InstructionProvider with ChangeNotifier {

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;



  List<InstructionModel> _instructionList = [];
  List<InstructionModel> get instructionList => _instructionList;

    Future<void> AddInstructions(InstructionModel instruction) async {
    _isLoading = true;
    notifyListeners();



    try {
      await _firestore.collection('instructions').add(instruction.toMap());
      await fetchAllInstruction(); // refresh list
    } catch (e) {
      debugPrint("Error adding instruction: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

    // 🔹 Fetch All Instruction
  Future<void> fetchAllInstruction() async {
    try {
      final snapshot = await _firestore.collection('instructions').get();
      _instructionList = snapshot.docs
          .map((doc) =>InstructionModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching instruction: $e");
    }
  }

  Future<void> updateinstructions(String docId, InstructionModel instruction) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('instructions').doc(docId).update(instruction.toMap());
      await fetchAllInstruction();
    } catch (e) {
      debugPrint("Error updating instructions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



   // 🔹 Delete Instruction
  Future<void> deleteInstruction(String docId) async {
    try {
      await _firestore.collection('instructions').doc(docId).delete();
      _instructionList.removeWhere((m) => m.id == docId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting instructions: $e");
    }
  }





  
}