import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indian_app_guy_test_ppt_generator/presentation/widgets/custom_appbar.dart';
import '../../../core/constants/api_constants.dart';
import '../../blocs/presentation/presentation_bloc.dart';
import '../../blocs/presentation/presentation_event.dart';
import '../../blocs/presentation/presentation_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../data/models/presentation_request_model.dart';
import '../../../core/constants/presentation_constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../result/result_screen.dart';
import '../../blocs/presentation_form/presentation_form_cubit.dart';
import '../../blocs/presentation_form/presentation_form_state.dart';
import '../../widgets/error_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _presentationForController = TextEditingController();

  // Watermark controllers
  final _watermarkUrlController = TextEditingController();
  final _watermarkWidthController = TextEditingController(text: '48');
  final _watermarkHeightController = TextEditingController(text: '48');

  @override
  void dispose() {
    _topicController.dispose();
    _presentationForController.dispose();
    _watermarkUrlController.dispose();
    _watermarkWidthController.dispose();
    _watermarkHeightController.dispose();
    super.dispose();
  }

  void _generatePresentation(
    BuildContext context,
    PresentationFormState formState,
  ) {
    if (_formKey.currentState!.validate()) {
      final userState = context.read<AuthBloc>().state;
      String email = '';
      if (userState is AuthAuthenticated) {
        email = userState.user.email;
      }

      Map<String, String>? watermark;
      if (_watermarkUrlController.text.isNotEmpty) {
        watermark = {
          'brandURL': _watermarkUrlController.text,
          'width': _watermarkWidthController.text.isNotEmpty
              ? _watermarkWidthController.text
              : '48',
          'height': _watermarkHeightController.text.isNotEmpty
              ? _watermarkHeightController.text
              : '48',
          'position': formState.watermarkPosition,
        };
      }

      final request = PresentationRequestModel(
        topic: _topicController.text,
        email: email,
        accessId: ApiConstants.magicSlidesAccessId,
        template: formState.template,
        language: formState.language,
        slideCount: formState.slideCount,
        aiImages: formState.aiImages,
        imageForEachSlide: formState.imageForEachSlide,
        googleImage: formState.googleImage,
        googleText: formState.googleText,
        model: formState.model,
        presentationFor: _presentationForController.text.isNotEmpty
            ? _presentationForController.text
            : null,
        watermark: watermark,
      );

      context.read<PresentationBloc>().add(
        GeneratePresentationRequested(request),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PresentationBloc, PresentationState>(
      listener: (context, state) {
        if (state is PresentationSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ResultScreen(presentation: state.presentation),
            ),
          );
        } else if (state is PresentationError) {
          ErrorDialog.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is PresentationLoading;
        return LoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            appBar: const CustomAppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: BlocBuilder<PresentationFormCubit, PresentationFormState>(
                  builder: (context, formState) {
                    return ListView(
                      children: [
                        const Text(
                          'Create Presentation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // TOPIC INPUT
                        CustomTextField(
                          controller: _topicController,
                          label: 'Topic',
                          hint: 'Enter your topic...',
                          prefixIcon: Icons.topic,

                          validator: (value) =>
                              (value == null ||
                                  value.isEmpty ||
                                  value.length < 3)
                              ? 'Topic must be at least 3 characters'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // TEMPLATE TYPE (Default / Editable)
                        Row(
                          children: [
                            const Text(
                              'Template Type:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 16),
                            ChoiceChip(
                              label: const Text('Default'),
                              selected: !formState.isEditable,
                              onSelected: (selected) {
                                context
                                    .read<PresentationFormCubit>()
                                    .toggleTemplateType(!selected);
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Editable'),
                              selected: formState.isEditable,
                              onSelected: (selected) {
                                context
                                    .read<PresentationFormCubit>()
                                    .toggleTemplateType(selected);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // TEMPLATE DROPDOWN (Using InputDecorator + DropdownButton)
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Select Template',
                            border: OutlineInputBorder(),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: formState.template,
                              isExpanded: true,
                              items:
                                  (formState.isEditable
                                          ? PresentationConstants
                                                .editableTemplates
                                          : PresentationConstants
                                                .defaultTemplates)
                                      .map(
                                        (t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(t),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  context
                                      .read<PresentationFormCubit>()
                                      .updateTemplate(val);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // SLIDE COUNT
                        Text('Slide Count: ${formState.slideCount}'),
                        Slider(
                          value: formState.slideCount.toDouble(),
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: formState.slideCount.toString(),
                          onChanged: (val) {
                            context
                                .read<PresentationFormCubit>()
                                .updateSlideCount(val.toInt());
                          },
                        ),
                        const SizedBox(height: 16),

                        // LANGUAGE & MODEL
                        Row(
                          children: [
                            Expanded(
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Language',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: formState.language,
                                    isExpanded: true,
                                    items: PresentationConstants
                                        .supportedLanguages
                                        .map(
                                          (l) => DropdownMenuItem(
                                            value: l,
                                            child: Text(l.toUpperCase()),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        context
                                            .read<PresentationFormCubit>()
                                            .updateLanguage(val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Model',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: formState.model,
                                    isExpanded: true,
                                    items: PresentationConstants.models
                                        .map(
                                          (m) => DropdownMenuItem(
                                            value: m,
                                            child: Text(m),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        context
                                            .read<PresentationFormCubit>()
                                            .updateModel(val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // PRESENTATION FOR
                        CustomTextField(
                          controller: _presentationForController,
                          label: 'Presentation For (Optional)',
                          hint: 'e.g. Student, Teacher, Business',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),

                        // TOGGLES
                        SwitchListTile(
                          title: const Text('AI Images'),
                          value: formState.aiImages,
                          onChanged: (val) {
                            context
                                .read<PresentationFormCubit>()
                                .toggleAiImages(val);
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Image on Each Slide'),
                          value: formState.imageForEachSlide,
                          onChanged: (val) {
                            context
                                .read<PresentationFormCubit>()
                                .toggleImageForEachSlide(val);
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Google Images'),
                          value: formState.googleImage,
                          onChanged: (val) {
                            context
                                .read<PresentationFormCubit>()
                                .toggleGoogleImage(val);
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Google Text'),
                          value: formState.googleText,
                          onChanged: (val) {
                            context
                                .read<PresentationFormCubit>()
                                .toggleGoogleText(val);
                          },
                        ),

                        // WATERMARK SECTION
                        ExpansionTile(
                          title: const Text('Watermark Settings (Optional)'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: _watermarkUrlController,
                                    label: 'Logo URL',
                                    hint: 'https://example.com/logo.png',
                                    prefixIcon: Icons.link,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          controller: _watermarkWidthController,
                                          label: 'Width',
                                          hint: '48',
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextField(
                                          controller:
                                              _watermarkHeightController,
                                          label: 'Height',
                                          hint: '48',
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: 'Position',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: formState.watermarkPosition,
                                        items:
                                            [
                                                  'BottomRight',
                                                  'BottomLeft',
                                                  'TopRight',
                                                  'TopLeft',
                                                ]
                                                .map(
                                                  (p) => DropdownMenuItem(
                                                    value: p,
                                                    child: Text(p),
                                                  ),
                                                )
                                                .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            context
                                                .read<PresentationFormCubit>()
                                                .updateWatermarkPosition(val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // GENERATE BUTTON
                        CustomButton(
                          onPressed: () =>
                              _generatePresentation(context, formState),
                          text: 'Generate Presentation',
                          isLoading: isLoading,
                          icon: Icons.auto_awesome,
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
