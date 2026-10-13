// //sourceView =>object sourViewModel
// // sourViewModel => object  SourceRepository
// // SourceRepository => object sourceRemoteDataSource
// // sourceRemoteDataSource => DioManger
//
// import 'package:news/data/repository/news/data_sources/remote/impl/news_remote_data_source_impl.dart';
// import 'package:news/data/repository/news/data_sources/remote/news_remote_data_source.dart';
// import 'package:news/data/repository/news/repository/impl/news_repository_impl.dart';
// import 'package:news/data/repository/news/repository/news_repository.dart';
// import 'package:news/data/repository/sources/data_sources/local/impl/source_local_data_source_impl.dart';
// import 'package:news/data/repository/sources/data_sources/local/source_local_data_source.dart';
// import 'package:news/data/repository/sources/data_sources/remote/impl/source_remote_data_source_impl.dart';
// import 'package:news/data/repository/sources/data_sources/remote/source_remote_data_source.dart';
// import 'package:news/data/repository/sources/repository/impl/source_repository_impl.dart';
// import 'package:news/dio/dio_manager.dart';
//
// import '../data/repository/sources/repository/source_repository.dart';
//
// SourceRepository injectSourceRepository(){
//   return SourceRepositoryImpl(sourceRemoteDataSource: injectSourceDataSource(),sourceLocalDataSource:  injectsourceLocal());
// }
// SourceLocalDataSource injectsourceLocal(){
//   return SourceLocalDataSourceImpl();
// }
// SourceRemoteDataSource injectSourceDataSource(){
//   return SourceRemoteDataSourceImpl(dioManager: injectDioManger());
// }
// DioManager injectDioManger(){
//   return DioManager();
// }
//
// NewsRepository injectNewsRepository(){
//   return NewsRepositoryImpl(newsRemoteDataSource: injectNewsRemoteDataSource());
// }
// NewsRemoteDataSource injectNewsRemoteDataSource(){
//   return NewsRemoteDataSourceImpl(dioManager: injectDioManger());
// }
