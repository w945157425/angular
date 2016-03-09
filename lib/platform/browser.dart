library angular2.platform.browser;

import "dart:async";
export "package:angular2/src/core/angular_entrypoint.dart"
    show AngularEntrypoint;
export "package:angular2/src/platform/browser_common.dart"
    show
        BROWSER_PROVIDERS,
        ELEMENT_PROBE_PROVIDERS,
        ELEMENT_PROBE_PROVIDERS_PROD_MODE,
        inspectNativeElement,
        BrowserDomAdapter,
        By,
        Title,
        DOCUMENT,
        enableDebugTools,
        disableDebugTools;
import "package:angular2/src/facade/lang.dart" show Type, isPresent;
import "package:angular2/src/platform/browser_common.dart"
    show BROWSER_PROVIDERS, BROWSER_APP_COMMON_PROVIDERS;
import "package:angular2/compiler.dart" show COMPILER_PROVIDERS;
import "package:angular2/core.dart" show ComponentRef, platform, reflector;
import "package:angular2/src/core/reflection/reflection_capabilities.dart"
    show ReflectionCapabilities;
import "package:angular2/src/platform/browser/xhr_impl.dart" show XHRImpl;
import "package:angular2/compiler.dart" show XHR;
import "package:angular2/src/core/di.dart" show Provider;

/**
 * An array of providers that should be passed into `application()` when bootstrapping a component.
 */
const List<dynamic> BROWSER_APP_PROVIDERS = const [
  BROWSER_APP_COMMON_PROVIDERS,
  COMPILER_PROVIDERS,
  const Provider(XHR, useClass: XHRImpl)
];
/**
 * Bootstrapping for Angular applications.
 *
 * You instantiate an Angular application by explicitly specifying a component to use
 * as the root component for your application via the `bootstrap()` method.
 *
 * ## Simple Example
 *
 * Assuming this `index.html`:
 *
 * ```html
 * <html>
 *   <!-- load Angular script tags here. -->
 *   <body>
 *     <my-app>loading...</my-app>
 *   </body>
 * </html>
 * ```
 *
 * An application is bootstrapped inside an existing browser DOM, typically `index.html`.
 * Unlike Angular 1, Angular 2 does not compile/process providers in `index.html`. This is
 * mainly for security reasons, as well as architectural changes in Angular 2. This means
 * that `index.html` can safely be processed using server-side technologies such as
 * providers. Bindings can thus use double-curly `{{ syntax }}` without collision from
 * Angular 2 component double-curly `{{ syntax }}`.
 *
 * We can use this script code:
 *
 * {@example core/ts/bootstrap/bootstrap.ts region='bootstrap'}
 *
 * When the app developer invokes `bootstrap()` with the root component `MyApp` as its
 * argument, Angular performs the following tasks:
 *
 *  1. It uses the component's `selector` property to locate the DOM element which needs
 *     to be upgraded into the angular component.
 *  2. It creates a new child injector (from the platform injector). Optionally, you can
 *     also override the injector configuration for an app by invoking `bootstrap` with the
 *     `componentInjectableBindings` argument.
 *  3. It creates a new `Zone` and connects it to the angular application's change detection
 *     domain instance.
 *  4. It creates an emulated or shadow DOM on the selected component's host element and loads the
 *     template into it.
 *  5. It instantiates the specified component.
 *  6. Finally, Angular performs change detection to apply the initial data providers for the
 *     application.
 *
 *
 * ## Bootstrapping Multiple Applications
 *
 * When working within a browser window, there are many singleton resources: cookies, title,
 * location, and others. Angular services that represent these resources must likewise be
 * shared across all Angular applications that occupy the same browser window. For this
 * reason, Angular creates exactly one global platform object which stores all shared
 * services, and each angular application injector has the platform injector as its parent.
 *
 * Each application has its own private injector as well. When there are multiple
 * applications on a page, Angular treats each application injector's services as private
 * to that application.
 *
 * ## API
 *
 * - `appComponentType`: The root component which should act as the application. This is
 *   a reference to a `Type` which is annotated with `@Component(...)`.
 * - `customProviders`: An additional set of providers that can be added to the
 *   app injector to override default injection behavior.
 *
 * Returns a `Promise` of [ComponentRef].
 */
Future<ComponentRef> bootstrap(Type appComponentType,
    [List<dynamic> customProviders]) {
  reflector.reflectionCapabilities = new ReflectionCapabilities();
  var appProviders = isPresent(customProviders)
      ? [BROWSER_APP_PROVIDERS, customProviders]
      : BROWSER_APP_PROVIDERS;
  return platform(BROWSER_PROVIDERS)
      .application(appProviders)
      .bootstrap(appComponentType);
}
