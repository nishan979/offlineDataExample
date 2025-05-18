import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = false.obs;
  var isOffline = false.obs;

  late Box<Post> postBox;

  @override
  void onInit() {
    super.onInit();
    postBox = Hive.box<Post>('posts');
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading(true);
    try {
      final response =
          await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final fetchedPosts = jsonList.map((e) => Post.fromJson(e)).toList();

        posts.assignAll(fetchedPosts);

        await postBox.clear();
        await postBox.addAll(fetchedPosts);

        isOffline(false);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      isOffline(true);
      posts.assignAll(postBox.values.toList());
    } finally {
      isLoading(false);
    }
  }
}
