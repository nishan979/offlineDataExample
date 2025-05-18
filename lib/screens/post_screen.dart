import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';

class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);

  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Obx(() => controller.isOffline.value
              ? const Icon(Icons.signal_wifi_off)
              : const Icon(Icons.wifi))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.posts.isEmpty) {
          return const Center(child: Text("No data available"));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchPosts,
          child: ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          ),
        );
      }),
    );
  }
}
