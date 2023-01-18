import 'package:alcancia/src/shared/graphql/queries/kyc_cancel_query.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:metamap_plugin_flutter/metamap_plugin_flutter.dart';

import '../../features/registration/model/GraphQLConfig.dart';

class MetamapService {
  final metamapClientId = dotenv.env['METAMAP_CLIENT_ID'] as String;
  final metamapDomicanFlowId = dotenv.env['DOMINICAN_FLOW_ID'] as String;
  final metamapMexicanResidentId = dotenv.env['MEXICO_RESIDENTS_FLOW_ID'] as String;
  final metamapMexicanINEId = dotenv.env['MEXICO_INE_FLOW_ID'] as String;

  Future<bool> cancelKycStatus() async {
    try {
      StorageService service = StorageService();
      var token = await service.readSecureData("token");
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.query(QueryOptions(document: gql(kycCancelQuery)));
      if (result.hasException) {
        final error = result.exception;
        return Future.error(error!);
      } else if (result.data != null) {
        print(result.data);
        return true;
      }
      return false;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  void showMatiFlow(String flowId, String uid) async {
    print(flowId);
    await MetaMapFlutter.showMetaMapFlow(metamapClientId, flowId, {"uid": uid, "buttonColor": "4E76E5"});
    final result = await MetaMapFlutter.resultCompleter.future;
    await Fluttertoast.showToast(
        msg: result is ResultSuccess
            ? "Verificación completada, revisión en proceso..."
            : "Cancelada",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
    if (result is ResultCancelled) {
      await cancelKycStatus();
    }
  }
}
