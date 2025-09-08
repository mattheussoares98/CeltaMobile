import 'package:flutter_test/flutter_test.dart';

void main() {
  // late AuthManagerDataSource sut;

  // late SupabaseClientSpy supabaseClient;

  // late User? user;

  void initSut() {
    // sut = AuthManagerDataSource(supabaseClient);
  }

  void initInjections() {
    // supabaseClient = SupabaseClientSpy();
  }

  // void mockSuccess() {}

  void initEntities() {
    // user = User(
    //   id: faker.randomGenerator.string(10),
    //   appMetadata: {},
    //   userMetadata: {},
    //   aud: faker.randomGenerator.string(10),
    //   createdAt: faker.randomGenerator.string(10),
    // );
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    // mockSuccess();
  });

  //! Needs to create the auth on supabase spy. I wont do this
  // group('get current user', () {
  //   test('should return the correct user', () {
  // supabaseClient.mockResponse(user);

  // sut.getCurrentUser();

  // verify(() => supabaseClient.auth.currentUser);
  //   });
  // });
}
