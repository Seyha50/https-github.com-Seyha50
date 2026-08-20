import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/models/contact_model.dart';
import 'package:bbusrd104/services/contact_service.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactService _contactService = ContactService();

  Future<void> _confirmDelete(String id, String name) async {
    final isDeleted = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text("Are you sure you want to delete contact: '$name'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (isDeleted == true) {
      EasyLoading.show();
      try {
        final success = await _contactService.deleteContact(id);
        if (success == true) {
          EasyLoading.showSuccess('One contact has been deleted!');
        } else {
          EasyLoading.showError('Failed to delete the contact!');
        }
      } catch (e) {
        EasyLoading.showError('Error deleting contact!');
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void _addContactDialog() {
    final keyForm = GlobalKey<FormState>();
    final txtfirstName = TextEditingController();
    final txtlastName = TextEditingController();
    final txtphone = TextEditingController();
    final txtcompany = TextEditingController();
    String? selectedGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Form(
            key: keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'New Contact',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required First name!';
                      }
                      return null;
                    },
                    controller: txtfirstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required Last name!';
                      }
                      return null;
                    },
                    controller: txtlastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a gender!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.transgender,
                        color: AppColors.bgColor,
                      ),
                    ),
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required Phone Number!';
                      }
                      if (value.trim().length < 9) {
                        return 'Phone Number must be at least 9 characters!';
                      }
                      return null;
                    },
                    controller: txtphone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtcompany,
                    decoration: InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppColors.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (keyForm.currentState!.validate()) {
                        EasyLoading.show();
                        try {
                          final contact = ContactModel(
                            id: '',
                            firstName: txtfirstName.text.trim(),
                            lastName: txtlastName.text.trim(),
                            gender: selectedGender!,
                            phone: txtphone.text.trim(),
                            company: txtcompany.text.trim(),
                          );
                          await _contactService.adContact(contact);
                          EasyLoading.dismiss();
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                          EasyLoading.showSuccess('Contact added!');
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError('Failed to add contact!');
                        }
                      }
                    },
                    icon: Icon(Icons.save, color: AppColors.white),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateContactDialog(ContactModel contact) {
    final keyForm = GlobalKey<FormState>();
    final txtfirstName = TextEditingController(text: contact.firstName);
    final txtlastName = TextEditingController(text: contact.lastName);
    final txtphone = TextEditingController(text: contact.phone);
    final txtcompany = TextEditingController(text: contact.company);
    String selectedGender = contact.gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Form(
            key: keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Update Contact',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required First name!';
                      }
                      return null;
                    },
                    controller: txtfirstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person, color: AppColors.bgColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required Last name!';
                      }
                      return null;
                    },
                    controller: txtlastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a gender!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.transgender,
                        color: AppColors.bgColor,
                      ),
                    ),
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          selectedGender = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required Phone Number!';
                      }
                      if (value.trim().length < 9) {
                        return 'Phone Number must be at least 9 characters!';
                      }
                      return null;
                    },
                    controller: txtphone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtcompany,
                    decoration: InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColors.bgColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppColors.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (keyForm.currentState!.validate()) {
                        EasyLoading.show();
                        try {
                          final updatedContact = ContactModel(
                            id: contact.id,
                            firstName: txtfirstName.text.trim(),
                            lastName: txtlastName.text.trim(),
                            gender: selectedGender,
                            phone: txtphone.text.trim(),
                            company: txtcompany.text.trim(),
                          );

                          await _contactService.updateContact(updatedContact);
                          EasyLoading.dismiss();
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                          EasyLoading.showSuccess('Contact updated!');
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError('Failed to update contact!');
                        }
                      }
                    },
                    icon: Icon(Icons.save, color: AppColors.white),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () => _addContactDialog(),
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: StreamBuilder<List<ContactModel>>(
        stream: _contactService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final contacts = snapshot.data ?? [];
          if (contacts.isEmpty) {
            return const Center(child: Text('No contact found...'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final mycontact = contacts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _updateContactDialog(mycontact),
                  onLongPress: () => _updateContactDialog(mycontact),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Avatar Initial
                        CircleAvatar(
                          backgroundColor: AppColors.bgColor,
                          child: Text(
                            mycontact.firstName.isNotEmpty
                                ? mycontact.firstName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Main Contact Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${mycontact.firstName} ${mycontact.lastName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${mycontact.gender}, ${mycontact.phone}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Optional Tag/Chip
                        if (mycontact.company != null &&
                            mycontact.company!.isNotEmpty) ...[
                          Chip(
                            label: Text(
                              mycontact.company!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor:
                                AppColors.bgColor.shade50,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],

                        // Delete Action Button
                        IconButton(
                          onPressed: () {
                            String name =
                                '${mycontact.firstName} ${mycontact.lastName}';
                            _confirmDelete(mycontact.id, name);
                          },
                          icon: Icon(Icons.delete, color: AppColors.red),
                          tooltip: 'Delete Contact',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}