
abstract class ImagePickerState {}

class ImageInitial extends ImagePickerState {}
class ImageLoading extends ImagePickerState {}
class ImageLoaded extends ImagePickerState {}
class ImageError extends ImagePickerState {
  final String message;
  ImageError({required this.message});
}

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  ImagePickerCubit() : super(ImageInitial());

  List<XFile> get images => _images;

  Future<void> pickMultipleImages() async {
    emit(ImageLoading());
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        _images.addAll(pickedImages);
        emit(ImageLoaded());
      } else {
        emit(ImageError(message: "No images selected"));
      }
    } catch (e) {
      emit(ImageError(message: "Failed to pick images: $e"));
    }
  }

  Future<void> captureImageWithCamera() async {
    emit(ImageLoading());
    try {
      final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);
      if (capturedImage != null) {
        _images.add(capturedImage);
        emit(ImageLoaded());
      } else {
        emit(ImageError(message: "No image captured"));
      }
    } catch (e) {
      emit(ImageError(message: "Failed to capture image: $e"));
    }
  }

  void removeImage(int index) {
    _images.removeAt(index);
    emit(ImageLoaded());
  }
}

class ImageUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImagePickerCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload Images", style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: BlocConsumer<ImagePickerCubit, ImagePickerState>(
          listener: (context, state) {
            if (state is ImageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red,),
              );
            }
          },
          builder: (context, state) {
            final images = context.watch<ImagePickerCubit>().images;

            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 260,
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: DashedBorder.fromBorderSide(dashLength: 6, side: BorderSide(color: Colors.teal, width: 1.5),),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_rounded, size: 50, color: Colors.teal),
                          SizedBox(height: 5),
                          Text("Upload Your Images", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal,),),
                          SizedBox(height: 3),
                          Text("Choose an image file from your gallery\nor capture a photo using the camera", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey),),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ImagePickerCubit>().pickMultipleImages();
                            },
                            icon: Icon(Icons.photo_library,color: Colors.white),
                            label: Text("Browse Gallery", style: TextStyle(fontSize: 14,color:Colors.black54 ),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            ),
                          ),

                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ImagePickerCubit>().captureImageWithCamera();
                              },
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            label: Text("Capture Image with Camera", style: TextStyle(fontSize: 14,color:Colors.black54 ),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: images.isNotEmpty ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(image.path), fit: BoxFit.cover),),
                              Positioned(
                                top: 7,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => context.read<ImagePickerCubit>().removeImage(index),
                                  child: CircleAvatar(radius: 16, backgroundColor: Colors.red, child: Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                          : Text("No images selected yet", style: TextStyle(fontSize: 14, color: Colors.grey),),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}