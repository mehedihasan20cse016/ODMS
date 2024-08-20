import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageDoctorPage extends StatefulWidget {
  @override
  _ManageDoctorPageState createState() => _ManageDoctorPageState();
}

class _ManageDoctorPageState extends State<ManageDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialistInController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serviceTimeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isUpdating = false;
  String? _currentDoctorId;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _specialistInController.dispose();
    _serviceChargeController.dispose();
    _descriptionController.dispose();
    _serviceTimeController.dispose();
    _imageUrlController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addOrUpdateDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_isUpdating && _currentDoctorId != null) {
        // Update existing doctor
        await FirebaseFirestore.instance
            .collection('manage_doctors')
            .doc(_currentDoctorId)
            .update({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'email': _emailController.text,
          'specialist_in': _specialistInController.text,
          'service_charge': double.parse(_serviceChargeController.text),
          'description': _descriptionController.text,
          'service_time': _serviceTimeController.text,
          'image_url': _imageUrlController.text,
          'phone': _phoneController.text,
        });

        _clearFields(); // Clear fields after update
      } else {
        // Add new doctor
        await FirebaseFirestore.instance.collection('manage_doctors').add({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'email': _emailController.text,
          'specialist_in': _specialistInController.text,
          'service_charge': double.parse(_serviceChargeController.text),
          'description': _descriptionController.text,
          'service_time': _serviceTimeController.text,
          'image_url': _imageUrlController.text,
          'phone': _phoneController.text,
        });

        _clearFields(); // Clear fields after adding
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _emailController.clear();
    _specialistInController.clear();
    _serviceChargeController.clear();
    _descriptionController.clear();
    _serviceTimeController.clear();
    _imageUrlController.clear();
    _phoneController.clear();
    setState(() {
      _isUpdating = false;
      _currentDoctorId = null;
    });
  }

  void _deleteDoctor(String id) async {
    await FirebaseFirestore.instance
        .collection('manage_doctors')
        .doc(id)
        .delete();
  }

  void _editDoctor(DocumentSnapshot doctor) {
    setState(() {
      _isUpdating = true;
      _currentDoctorId = doctor.id;
      _nameController.text = doctor['name'];
      _ageController.text = doctor['age'].toString();
      _emailController.text = doctor['email'];
      _specialistInController.text = doctor['specialist_in'];
      _serviceChargeController.text = doctor['service_charge'].toString();
      _descriptionController.text = doctor['description'];
      _serviceTimeController.text = doctor['service_time'];
      _imageUrlController.text = doctor['image_url'];
      _phoneController.text = doctor['phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Doctors'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _specialistInController,
                      decoration: InputDecoration(labelText: 'Specialist In'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter specialist';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _serviceChargeController,
                      decoration: InputDecoration(labelText: 'Service Charge'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter service charge';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _serviceTimeController,
                      decoration: InputDecoration(labelText: 'Service Time'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter service time';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter image URL';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _addOrUpdateDoctor,
                          child: Text(
                              _isUpdating ? 'Update Doctor' : 'Add Doctor'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _clearFields,
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('manage_doctors')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No doctors found'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Age')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Specialist In')),
                        DataColumn(label: Text('Service Charge')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Service Time')),
                        DataColumn(label: Text('Image URL')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: snapshot.data!.docs.map<DataRow>((doc) {
                        return DataRow(
                          cells: [
                            DataCell(Text(doc['name'] ?? '')),
                            DataCell(Text(doc['age'].toString() ?? '')),
                            DataCell(Text(doc['email'] ?? '')),
                            DataCell(Text(doc['specialist_in'] ?? '')),
                            DataCell(
                                Text(doc['service_charge'].toString() ?? '')),
                            DataCell(Text(doc['description'] ?? '')),
                            DataCell(Text(doc['service_time'] ?? '')),
                            DataCell(Text(doc['image_url'] ?? '')),
                            DataCell(Text(doc['phone'] ?? '')),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editDoctor(doc);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteDoctor(doc.id);
                                  },
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
