class ApiUrl {
  static const _baseUrl = "https://task.teamrabbil.com/api/v1";

  static const registration = "$_baseUrl/registration";
  static const login = "$_baseUrl/login";
  static const profileUpdate = "$_baseUrl/profileUpdate";
  static const createTask = "$_baseUrl/createTask";

  static updateTaskStatus(String id, String status) => "$_baseUrl/updateTaskStatus/$id/$status";

  static String deleteTask(String id) => "$_baseUrl/deleteTask/$id";

  static const taskStatusCount = "$_baseUrl/taskStatusCount";
  static const recoverVerifyEmail = "$_baseUrl/RecoverVerifyEmail";
  static const recoverVerifyOTP = "$_baseUrl/RecoverVerifyOTP";
  static const recoverResetPass = "$_baseUrl/RecoverResetPass";

  //task by status
  static const newTask = "$_baseUrl/listTaskByStatus/New";
  static const completeTask = "$_baseUrl/listTaskByStatus/Completed";
  static const progressTask = "$_baseUrl/listTaskByStatus/Progress";
  static const canceledTask = "$_baseUrl/listTaskByStatus/Canceled";
}