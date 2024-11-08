
class Urls{

  static const String baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registration = '$baseUrl/Registration';

  static const String login = '$baseUrl/Login';

  static const String addTask = '$baseUrl/createTask';

  static const String newTask = '$baseUrl/listTaskByStatus/New';

  static const String completedTask = '$baseUrl/listTaskByStatus/Completed';

  static const String inProgressTask = '$baseUrl/listTaskByStatus/In progress';

  static const String cancelledTask = '$baseUrl/listTaskByStatus/Cancelled';

  static String changeStatus(String taskId, String status, )=> '$baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTask(String taskId)=> '$baseUrl/deleteTask/$taskId/';

  static const String countTask = '$baseUrl/taskStatusCount';

  static const String updateProfile = '$baseUrl/ProfileUpdate';

  static const String resetPass = '$baseUrl/RecoverResetPassword';


}