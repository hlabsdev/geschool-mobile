import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geschool/features/common/data/function_utils.dart';
import 'package:geschool/features/common/data/models/basemodels/detail_budget_model.dart';
import 'package:geschool/features/common/data/models/basemodels/user_model.dart';
import 'package:geschool/core/utils/colors.dart';
import 'package:geschool/features/launch/presentation/pages/budget/detail_budget.dart';
import 'package:geschool/core/utils/preference.dart';

class BudgetCardWidget extends StatelessWidget {
  const BudgetCardWidget({
    Key key,
    this.budget,
  }) : super(key: key);

  // final bool isAdmin;
  final DetailBudgetModel budget;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        focusColor: Colors.grey[300],
        leading: Icon(
          Icons.attach_money_rounded,
          color: Colors.grey[700],
          size: 50,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        title: SizedBox(
          width: (MediaQuery.of(context).size.width / 2),
          // Date
          child: Text(
            FunctionUtils.convertFormatDate(budget.dateOperation),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: GreenLight,
            ),
          ),
        ),
        subtitle: Container(
          padding: EdgeInsets.only(right: 8.0, bottom: 8),
          child: Column(
            children: [
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    // Nature
                    child: Text(
                      "Nature:",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    // Somme
                    child: Text(
                      "Somme:",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    // Nature
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 3),
                      child: Text(
                        (budget.natureFondLibelle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.blueGrey[800]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    // Somme
                    child: Text(
                      (budget.montantOperation),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DetailBudget(
                  budget: budget,
                  me: UserModel.fromJson(json.decode(UserPreferences().user)),
                ),
              ))
        },
      ),
    );
  }
}
