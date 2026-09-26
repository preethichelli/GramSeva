import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service.dart';
import '../../models/society.dart';
import '../../services/api_service.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import 'pending_verification_screen.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() =>
      _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final _api = ApiService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();

  List<ServiceCategory> _services = [];
  List<Society> _societies = [];
  final Set<String> _selectedSkills = {};
  Society? _selectedSociety;
  PlatformFile? _selectedFile;

  bool _loadingOptions = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    try {
      final services = await _api.getServices();
      final societies = await _api.getSocieties();
      setState(() {
        _services = services;
        _societies = societies;
      });
    } catch (_) {
      setState(() => _error =
          'Could not load services/societies. Is the backend running?');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  Future<void> _pickCertificate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    if (file.size > 5 * 1024 * 1024) {
      setState(() => _error = 'File must be under 5MB.');
      return;
    }
    setState(() {
      _selectedFile = file;
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedSkills.isEmpty ||
        _selectedSociety == null) {
      setState(() => _error =
          'Please fill in your name, phone, at least one skill, and your society.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      // TODO: replace with the real logged-in user's Firebase UID once auth is wired in
      await _api.registerWorker(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        firebaseUid: 'demo-worker-uid',
        societyId: _selectedSociety!.id,
        skills: _selectedSkills.toList(),
        experienceYears: int.tryParse(_experienceController.text.trim()) ?? 0,
      );
      if (!mounted) return;
      context.read<AppState>().setWorkerRegistered(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PendingVerificationScreen()),
      );
    } catch (e) {
      setState(() => _error = 'Could not submit registration. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join the co-op')),
      body: _loadingOptions
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.teal100,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: AppColors.deepTeal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your registration will be verified by your cooperative society before you can accept jobs.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.deepTeal),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _label('FULL NAME'),
                TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: 'Ramesh Kumar')),
                const SizedBox(height: 16),
                _label('PHONE NUMBER'),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(hintText: '+91 98765 43210'),
                ),
                const SizedBox(height: 16),
                _label('SELECT YOUR SKILLS'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _services.map((s) {
                    final selected = _selectedSkills.contains(s.slug);
                    return GestureDetector(
                      onTap: () => setState(() {
                        selected
                            ? _selectedSkills.remove(s.slug)
                            : _selectedSkills.add(s.slug);
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.saffron : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                              color: selected
                                  ? AppColors.saffron
                                  : AppColors.cardBorder),
                        ),
                        child: Text(
                          s.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _label('YEARS OF EXPERIENCE'),
                TextField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: '6'),
                ),
                const SizedBox(height: 16),
                _label('REGISTERED LABOUR COOPERATIVE SOCIETY'),
                const SizedBox(height: 8),
                DropdownButtonFormField<Society>(
                  initialValue: _selectedSociety,
                  isExpanded: true,
                  decoration: const InputDecoration(),
                  hint: const Text('Search society',
                      style: TextStyle(fontSize: 13, color: AppColors.slate)),
                  items: _societies
                      .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name,
                              style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (s) => setState(() => _selectedSociety = s),
                ),
                const SizedBox(height: 16),
                _label('CERTIFICATE / SOCIETY ID UPLOAD'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickCertificate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      border: Border.all(
                        color: _selectedFile != null
                            ? AppColors.saffron
                            : AppColors.cardBorder,
                      ),
                      color: AppColors.mist,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedFile != null
                              ? Icons.check_circle_outline
                              : Icons.upload_outlined,
                          color: AppColors.deepTeal,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedFile != null
                              ? _selectedFile!.name
                              : 'Tap to upload document',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedFile != null
                              ? 'Tap to change file'
                              : 'PDF, PNG or JPG (Max 5MB)',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.mutedGrey),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 12)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Submit for verification'),
                ),
              ],
            ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryGrey,
            letterSpacing: 0.3),
      );
}
