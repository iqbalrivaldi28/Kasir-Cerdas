import 'package:flutter/material.dart';

bodyWithAppbarHeight(context) =>
    MediaQuery.of(context).size.height -
    (MediaQuery.of(context).padding.top + kToolbarHeight) -
    32;
