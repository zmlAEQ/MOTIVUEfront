# Motivue Backend 参考（前端对接版）

本文件汇总后端仓库 (`Motivue-Backend`) 的核心结构、接口与数据字段，供前端对接时查阅。

## 仓库结构速览
- apps/*：微服务入口 (FastAPI)
  - readiness-api：日准备度计算 + 训练消耗写库。
  - weekly-report-api：周报生成（LLM/规则）、Markdown/HTML + ChartSpec。
  - baseline-api：睡眠/HRV 基线服务。
  - physio-age-api：生理年龄 (HRV/RHR + CSS)。
  - auth-api：最小 JWT 登录。
- libs/*：领域库
  - readiness_engine：贝叶斯准备度核心、Hooper/睡眠/HRV 映射、个性化 CPT。
  - weekly_report：趋势图生成、洞察、LLM 多阶段、Finalizer Markdown/HTML。
  - training：训练消耗 AU → readiness 扣减。
  - analytics：基线计算/存储；daily vs baseline 比较。
  - core_domain：共享 Pydantic/SQLAlchemy 模型；ChartSpec、WeeklyReportPackage 等。
  - physio：生理年龄计算（CSS 在 physio/css.py）。
- 样例与文档：
  - `samples/original_payload_sample.json`：日输入 + 7 日 history 示例。
  - `samples/*weekly_report*`：周报输出/Markdown/ChartSpec 示例。
  - `docs/weekly_report_frontend_notes.md`：前端字段与图表占位规范（强烈参考）。

## 关键接口（前端相关）
- POST `/readiness/from-healthkit`
  - 输入：sleep/HRV/Hooper/journal/previous_state_probs，支持 apple_sleep_score、cycle、daily_au、基线覆盖。
  - 输出：`final_readiness_score`、`final_diagnosis`、`final_posterior_probs`、`next_previous_state_probs`。写入 `user_daily`，并初始化 `current_readiness_score`（可被消耗扣减）。
- POST `/readiness/consumption`
  - 输入：training sessions（RPE×时长或 AU、标签）。
  - 输出：`consumption_score`、`display_readiness`（写回当前剩余准备度）。
- 训练/力量
  - POST `/training/session` (type_tags + AU/RPE/时长)；POST `/strength/record` (动作 PR)。
  - GET `/training/counts`、`/strength/latest`、`/strength/history`。
- 基线
  - GET `/baseline/{user_id}`：睡眠/HRV 基线；readiness 内部也会自动拉取。
- 周报
  - POST `/weekly-report/run`：返回 `phase3_state`(metrics/insights)、`package`(charts + analyst/communicator/critique)、`final_report`(markdown/html + chart_ids + CTA)。图表 ID：`readiness_trend`、`readiness_vs_hrv`、`hrv_trend`、`sleep_duration`、`sleep_structure`、`training_load`、`hooper_radar`、`lifestyle_timeline` 等。

## 数据字段清单
- 今日：`final_readiness_score`，`current_readiness_score`，`daily_au`，`acwr`（metrics），`hrv_rmssd_today`，`sleep_duration_hours` / `sleep_efficiency`，`hooper{fatigue,soreness,stress,sleep}`，`journal`（alcohol/late_caffeine/screen_before_bed/late_meal/is_sick/is_injured/lifestyle_tags/sliders）。
- 历史：`history[]`（readiness_score/band, hrv_rmssd, hrv_z_score, sleep_total/deep/rem, daily_au, lifestyle_events）。
- 训练与力量：`training_tag_counts`、`strength_levels`（周报 payload 可选字段）；训练会话/力量 PR 通过训练/力量接口读写。
- 建议/洞察：`phase3_state.insights`、`final_report.markdown_report`、`final_report.call_to_action[]`。

## 参考文件路径
- 后端综述：`Motivue-Backend/README.md`
- 前端集成细则：`Motivue-Backend/docs/weekly_report_frontend_notes.md`
- 样例 payload：`Motivue-Backend/samples/original_payload_sample.json`
- 周报示例输出：`Motivue-Backend/samples/*weekly_report*`
- readiness API 入口：`Motivue-Backend/apps/readiness-api/main.py`

## Next Steps（前端开发节奏建议）
1) 先做“只读”页面（例如训练计划列表或个人主页摘要），暂不接登录/表单提交，专注数据展示和样式。
2) 利用 Cursor/Copilot 做 HTML → SwiftUI 转换：把现有 HTML/CSS 片段喂给助手并提示  
   “Here is an HTML/CSS snippet for a card component. Convert this to a SwiftUI View using VStack/HStack.”
3) 等只读页面稳定后，再接入真实接口与登录/打卡表单，逐步接 readiness/weekly-report/训练接口。

## 实现要点（iOS/SwiftUI）
- 图表渲染：遵循 `docs/weekly_report_frontend_notes.md` 的 `[[chart:ID]]` 占位规则，按 `chart_ids` 顺序兜底。
- 断网/无值：缺失字段应优雅降级（隐藏卡片或显示 “—”），ACWR/HRV 等为 null 时不渲染数值。
- 交互：Journal 卡“Edit” → 打开问卷，提交后刷新 readiness；Train 页提交 session 后可刷新消耗并更新 Today 圆环。
- 颜色语义：ACWR 安全窗 0.6–1.3 → 绿色；偏高偏低用橙/红。Hooper 高分（疲劳/酸痛高）用暖色提示。

## 参考文件路径
- 后端综述：`Motivue-Backend/README.md`
- 前端集成细则：`Motivue-Backend/docs/weekly_report_frontend_notes.md`
- 样例 payload：`Motivue-Backend/samples/original_payload_sample.json`
- 周报示例输出：`Motivue-Backend/samples/*weekly_report*`
- readiness API 入口：`Motivue-Backend/apps/readiness-api/main.py`
