# Motivue 前后端打通计划（基于现有 UI）

## 目标
- 在当前已完成的多 Tab UI 基础上，接入 Motivue-Backend 的核心服务，形成可演示的数据流。
- 先用 mock + 占位，逐步切换真实接口，确保可增量交付。

## 后端服务映射（关键接口）
- Readiness: `POST /readiness/from-healthkit`（日准备度，返回 score/probs/metrics），`POST /readiness/consumption`（训练消耗扣减）。
- Weekly Report: `POST /weekly-report/run`（Phase 3/4/5，返回 charts+Markdown+CTA；调试可用 `use_llm=false`）。
- Baseline: `GET /baseline/{user_id}`（睡眠/HRV 基线）。
- Physio Age: `POST /physio-age`（生理年龄/最佳 z-score）。
- Training/Strength（选用）: `POST /training/session`、`POST /strength/record`、`GET /strength/latest|history`。
- Auth（选用）: `POST /auth/login|signup|refresh`，`GET /me`（Bearer token）。

## Swift 端需要的模型 & 网络层（已对齐主要字段，可按实际响应再补）
- 已建 `Networking/ApiService.swift`：baseURL/Bearer 预留，mock/real 切换，占位调用 readiness/consumption/weekly-report/baseline/physio-age。
- Codable 模型（snake_case→camelCase 用 CodingKeys）：
  - `ReadinessResponse`: user_id/date/final_readiness_score/current_readiness_score/final_diagnosis/final_posterior_probs/next_previous_state_probs/acwr/hrv_rmssd_today/sleep_duration_hours/metrics/insights/objective/journal/hooper/update_history。
  - `Metrics`: hrv_z_score/sleep_efficiency/restorative_ratio/acwr_7d/acwr_28d/sleep_baseline_hours/hrv_baseline_mu。
  - `TrainingConsumptionResponse`: consumption_score/display_readiness/base_readiness_score/breakdown[]。
  - `WeeklyReportResponse`: phase3_state{metrics/insights/next_week_plan}, package{charts/analyst/communicator/critique}, final_report{markdown_report/html_report/chart_ids/call_to_action/persisted}。
  - `ChartSpec`: chart_id/title/chart_type/data(JSONValue)。
  - `BaselineResponse`: sleep_baseline_hours/sleep_baseline_eff/rest_baseline_ratio/hrv_baseline_mu/hrv_baseline_sd。
  - `PhysioAgeResponse`: physiological_age/physiological_age_weighted/best_age_zscores/css_details/status/window_days_used。
  - `JSONValue`: 通用 JSON。
- Mock provider：`Networking/MockData.swift` 已提供 readiness/consumption/weekly-report/baseline/physio_age 示例数据；ViewModel 可切换 mock/real。

## 页面接入优先级
1) Home
   - 数据：`ReadinessResponse`（score、acwr、hrv、sleep、insights/evidence）。
   - “Why” 区：来自 `phase3_state.insights` 或 metrics 组装。
   - 日历：可先 mock 状态点，后续从历史 readiness/weekly report 状态填充。
2) Training
   - 消耗：`POST /readiness/consumption` 用于当日 AU 扣减；训练 session/strength 先 mock，预留接口调用。
   - 历史/力量：后续用 `/training/session` 和 `/strength/record` 补数据。
3) Report
   - `POST /weekly-report/run`（初期 `use_llm=false`），渲染 `final_report.markdown_report` + `package.charts[]`（按 `chart_id` 替换）。
4) Me
   - Physio Age：`POST /physio-age` 填充徽章/详情。
   - Baseline：`GET /baseline/{user_id}` 回显基线卡片。
5) Sleep
   - 先用 readiness 输入/metrics 补睡眠指标；若后端追加睡眠接口再替换。

## 开发节奏（建议迭代）
- 第 1 步：落地 ApiService + Codable 模型 + mock provider；不改 UI。
- 第 2 步：Home/Training 接 readiness/consumption（成功后更新 UI 绑定）。
- 第 3 步：Report 接 weekly-report（`use_llm=false` 调试），处理 Markdown/图表占位。
- 第 4 步：Me 接 physio-age/baseline；Sleep 补真实数据或保留 mock。
- 第 5 步：认证/缓存/错误提示等收尾。

## 现状与 gap
- UI 已完成（Home/Training/Journal/Sleep/Report/Me），部分已绑定 mock（Home/Training/Me/Report）。
- 模型/网络层已对齐主要字段；仍需用真实响应校验字段、补缺并绑定到 UI（尤其 Training/Sleep 真实数据）。
- `DEV_BACKEND_UI_REFERENCE.md` 需补充页面-接口绑定；Git 已可推送（origin=https://github.com/zmlAEQ/MOTIVUEfront）。
