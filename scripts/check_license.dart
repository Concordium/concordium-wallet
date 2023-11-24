// ignore_for_file: avoid_print
import 'dart:io';
import 'package:license_checker/src/config.dart';
import 'package:license_checker/src/check_license.dart';
import 'package:license_checker/src/dependency_checker.dart';
import 'package:license_checker/src/package_checker.dart';

void main() async {
  // Load the config file
  Config config = Config.fromFile(File('./scripts/license.yaml'));

  // Get the package configuration from the current directory
  PackageChecker packageConfig = await PackageChecker.fromCurrentDirectory(config: config);

  // Run the license check on all packages
  List<LicenseDisplayWithPriority<String>> lic = await checkAllPackageLicenses<String>(
    packageConfig: packageConfig,
    showDirectDepsOnly: false,
    filterApproved: true,
    licenseDisplay: ({
      required String licenseName,
      required String packageName,
      required LicenseStatus licenseStatus,
    }) =>
        '$packageName - $licenseName',
  );

  if (lic.isNotEmpty) {
    print('Unapproved licenses used, see below:');
    for (final x in lic) {
      print(x.display);
    }
    throw "Stopping due to unapproved licenses used!";
  }
}
