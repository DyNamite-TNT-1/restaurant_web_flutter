import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/enum/bloc.dart';
import 'package:restaurant_flutter/models/client/client_conversation.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';

import '../../models/client/client_message.dart';

part 'messenger_event.dart';
part 'messenger_state.dart';

class MessengerBloc extends Bloc<MessengerEvent, MessengerState> {
  static final String tagRequestMessages =
      Api.buildIncreaseTagRequestWithID("messengerBloc_messages");
  static final String tagRequestConversations =
      Api.buildIncreaseTagRequestWithID("messengerBloc_conversations");

  MessengerBloc(MessengerState state) : super(state) {
    on<OnLoadMessage>(_onLoadMessages);
    on<OnLoadConversation>(_onLoadConversations);
  }

  Future<void> _onLoadMessages(OnLoadMessage event, Emitter emit) async {
    int conversationId = event.params.containsKey("conversationId")
        ? event.params["conversationId"]
        : 0;
    if (!isClosed) {
      emit(state.copyWith(
        messageState: BlocState.loading,
      ));
      ResultModel result = await Api.requestDetailConversation(
        conversationId: conversationId,
        tagRequest: tagRequestMessages,
      );
      if (result.isSuccess) {
        ClientMessageModel clientMessageModel =
            ClientMessageModel.fromJson(result.data);
        emit(state.copyWith(
          clientMessageModel: clientMessageModel,
          messageState: clientMessageModel.messages.isEmpty
              ? BlocState.noData
              : BlocState.loadCompleted,
        ));
      } else {
        emit(state.copyWith(
          messageState: BlocState.loadFailed,
        ));
      }
    }
  }

  Future<void> _onLoadConversations(
      OnLoadConversation event, Emitter emit) async {
    if (!isClosed) {
      emit(state.copyWith(
        conversationState: BlocState.loading,
      ));
      ResultModel result = await Api.requestListConversation(
        tagRequest: tagRequestMessages,
      );
      if (result.isSuccess) {
        List<ClientConversationModel> clientConversationModel =
            ClientConversationModel.parseListItem(result.data["conversations"]);
        emit(state.copyWith(
          clientConversationModel: clientConversationModel,
          conversationState: clientConversationModel.isEmpty
              ? BlocState.noData
              : BlocState.loadCompleted,
        ));
      } else {
        emit(state.copyWith(
          conversationState: BlocState.loadFailed,
        ));
      }
    }
  }

  @override
  Future<void> close() async {
    super.close();
    Api.cancelRequest(tag: tagRequestMessages);
    Api.cancelRequest(tag: tagRequestConversations);
  }
}
