# Changelog

## [1.0.2](https://github.com/Olensys/terraform-aws-step-function/compare/v1.0.1...v1.0.2) (2026-10-24)


### Bug Fixes

* **examples:** unique application slug so concurrent integration runs do not collide ([#2](https://github.com/Olensys/terraform-aws-step-function/issues/2)) ([72177df](https://github.com/Olensys/terraform-aws-step-function/commit/72177df5e16ce2726d85b7e51c531b587ba777be))

## [1.0.1](https://github.com/Olensys/terraform-aws-step-function/compare/v1.0.0...v1.0.1) (2026-10-24)


### Bug Fixes

* **examples:** pin naming module to v1.0.1 ([3c44960](https://github.com/Olensys/terraform-aws-step-function/commit/3c44960eda9a733328aa0838a6ebfe21e3898da0))
* run integration on change and weekly instead of nightly ([6c48889](https://github.com/Olensys/terraform-aws-step-function/commit/6c48889d7329635772b5c4734762102e9439343f))

## 1.0.0

- Step Functions state machine wrapper with ALL-level execution logging, X-Ray tracing, a retained log group and an execution role scoped to the listed Lambda functions.
