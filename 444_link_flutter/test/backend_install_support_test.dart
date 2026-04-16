import 'dart:io';

import 'package:444_link_flutter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LinkBackendInstallSupport.selectInstallerUrl', () {
    test('prefers the Inno setup exe over legacy msi assets', () {
      final selected = LinkBackendInstallSupport.selectInstallerUrl([
        {
          'name': '444 Backend Installer-1.5.5.msi',
          'browser_download_url': 'https://example.com/backend-legacy.msi',
        },
        {
          'name': '444 Backend Setup-1.5.6.exe',
          'browser_download_url': 'https://example.com/backend-setup.exe',
        },
      ]);

      expect(selected, 'https://example.com/backend-setup.exe');
    });

    test('prefers installer exes over plain backend executables', () {
      final selected = LinkBackendInstallSupport.selectInstallerUrl([
        {
          'name': '444 Backend.exe',
          'browser_download_url': 'https://example.com/backend-app.exe',
        },
        {
          'name': '444 Backend Setup-1.5.6.exe',
          'browser_download_url': 'https://example.com/backend-setup.exe',
        },
      ]);

      expect(selected, 'https://example.com/backend-setup.exe');
    });

    test('falls back to msi when that is the only installer asset', () {
      final selected = LinkBackendInstallSupport.selectInstallerUrl([
        {
          'name': '444 Backend Installer-1.5.5.msi',
          'browser_download_url': 'https://example.com/backend-legacy.msi',
        },
      ]);

      expect(selected, 'https://example.com/backend-legacy.msi');
    });
  });

  group('LinkBackendInstallSupport.executableCandidatesForRoot', () {
    test('includes the staged Inno dist executable for a repo root', () {
      final root = ['C:', 'repo', '444-Backend'].join(Platform.pathSeparator);
      final candidates = LinkBackendInstallSupport.executableCandidatesForRoot(
        root,
      ).toList();

      expect(
        candidates,
        contains(
          [
            root,
            'dist',
            '444-Backend',
            '444 Backend.exe',
          ].join(Platform.pathSeparator),
        ),
      );
    });
  });
}
