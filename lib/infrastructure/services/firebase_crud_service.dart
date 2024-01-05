import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/model.dart';
import '../../domain/services/crud_service.dart';

abstract class FirebaseCrudService<T> extends CrudService<T> {
  final String collectionName;
  final FirebaseFirestore _collection = FirebaseFirestore.instance;
  final Function fromJson;
  FirebaseCrudService(this.collectionName, this.fromJson) : super() {
    _collection.settings = const Settings(persistenceEnabled: true);
    _collection.collection(collectionName);
  }

  @override
  Future<T> create(T entity) async {
    try {
      //has id
      if ((entity as Model).id?.isEmpty ?? true) {
        DocumentReference<Map<String, dynamic>> documentReference =
            await _collection.collection(collectionName).add((entity).toJson());
        return entity.fromJson(
            (entity).toJson()..addAll({'id': documentReference.id})) as T;
      }
      await _collection
          .collection(collectionName)
          .doc((entity).id)
          .set((entity).toJson());
      return entity;
    } catch (e) {
      log(e.toString());
    }
    return entity;
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _collection.collection(collectionName).doc(id).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<T>> list() async {
    try {
      final snapshot = await _collection.collection(collectionName).get();
      return snapshot.docs.map((e) {
        Map<String, dynamic> data = e.data();
        return fromJson(data) as T;
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<T?> read(String id) async {
    try {
      final snapshot =
          await _collection.collection(collectionName).doc(id).get();
      if (!snapshot.exists) {
        return null;
      }
      Map<String, dynamic> data = snapshot.data()!;
      return fromJson(data) as T;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<List<T>> readBy(String field, String value) async {
    try {
      final snapshot = await _collection
          .collection(collectionName)
          .where(field, isEqualTo: value)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((e) {
        return fromJson(e.data()) as T;
      }).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<T> update(T entity) async {
    try {
      await _collection
          .collection(collectionName)
          .doc((entity as Model).id)
          .update((entity).toJson());
      return entity;
    } catch (e) {
      log(e.toString());
      return null as T;
    }
  }
}
