import 'package:flutter/material.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/service.dart';

class ServiceRowItem extends StatelessWidget {
  const ServiceRowItem({
    super.key,
    required this.item,
  });

  final ServiceDetailModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: kPadding10, vertical: kPadding10 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.quantity.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: 100,
            child: Text(
              item.priceStr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
