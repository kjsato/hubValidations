test_that("expand_model_out_grid works correctly", {
  hub_con <- hubData::connect_hub(
    system.file("testhubs/flusight", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_snapshot(str(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02"
    )
  ))
  expect_snapshot(str(
    expand_model_out_grid(
      config_tasks,
      round_id = "2023-01-02",
      required_vals_only = TRUE
    )
  ))

  # Specifying a round in a hub with multiple rounds
  hub_con <- hubData::connect_hub(
    system.file("testhubs/simple", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_snapshot(str(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-01"
    )
  ))

  expect_snapshot(str(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-01",
      required_vals_only = TRUE
    )
  ))
  expect_snapshot(str(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-29",
      required_vals_only = TRUE
    )
  ))
  expect_snapshot(str(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-29",
      required_vals_only = TRUE,
      all_character = TRUE
    )
  ))
  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-29",
      required_vals_only = TRUE,
      as_arrow_table = TRUE
    )
  )
  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-10-29",
      required_vals_only = TRUE,
      all_character = TRUE,
      as_arrow_table = TRUE
    )
  )

  expect_snapshot(
    str(
      expand_model_out_grid(
        jsonlite::fromJSON(
          test_path(
            "testdata",
            "configs",
            "both_null_tasks.json"
          ),
          simplifyVector = TRUE,
          simplifyDataFrame = FALSE
        ),
        round_id = "2023-11-26"
      ) %>%
        dplyr::filter(is.na(horizon))
    )
  )

  expect_snapshot(
    str(
      expand_model_out_grid(
        jsonlite::fromJSON(
          test_path(
            "testdata",
            "configs",
            "both_null_tasks_swap.json"
          ),
          simplifyVector = TRUE,
          simplifyDataFrame = FALSE
        ),
        round_id = "2023-11-26"
      ) %>%
        dplyr::filter(is.na(horizon))
    )
  )
})

test_that("Setting of round_id value works correctly", {
  hub_con <- hubData::connect_hub(
    system.file("testhubs/simple", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")
  expect_equal(
    unique(
      expand_model_out_grid(
        config_tasks,
        round_id = "2022-10-01"
      )$origin_date
    ),
    as.Date("2022-10-01")
  )

  expect_equal(
    unique(
      expand_model_out_grid(
        config_tasks,
        required_vals_only = TRUE,
        round_id = "2022-10-29"
      )$origin_date
    ),
    as.Date("2022-10-29")
  )


  # Test in hub with single round
  hub_con <- hubData::connect_hub(
    system.file("testhubs/flusight", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_equal(
    unique(
      expand_model_out_grid(
        config_tasks,
        required_vals_only = TRUE,
        round_id = "2023-01-30"
      )$forecast_date
    ),
    as.Date("2023-01-30")
  )
})


test_that("expand_model_out_grid output controls work correctly", {
  hub_con <- hubData::connect_hub(
    system.file("testhubs/flusight", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_snapshot(str(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      all_character = TRUE
    )
  ))
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      all_character = TRUE,
      as_arrow_table = TRUE
    )
  )
  expect_snapshot(str(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      required_vals_only = TRUE,
      all_character = TRUE
    )
  ))
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      required_vals_only = TRUE,
      all_character = TRUE,
      as_arrow_table = TRUE
    )
  )
  expect_snapshot(str(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      required_vals_only = TRUE,
      all_character = TRUE,
      as_arrow_table = FALSE,
      bind_model_tasks = FALSE
    )
  ))
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2023-01-02",
      required_vals_only = TRUE,
      all_character = TRUE,
      as_arrow_table = TRUE,
      bind_model_tasks = FALSE
    )
  )
})


test_that("expand_model_out_grid output controls with samples work correctly", {
  # Hub with sample output type
  config_tasks <- hubUtils::read_config_file(system.file("config", "tasks.json",
    package = "hubValidations"
  ))


  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26"
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE
    ) %>%
      dplyr::filter(.data$output_type == "sample")
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      required_vals_only = TRUE,
      all_character = TRUE
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      required_vals_only = TRUE,
      as_arrow_table = TRUE
    )
  )
  # Hub with sample output type and compound task ID structure
  config_tasks <- hubUtils::read_config_file(
    system.file("config", "tasks-comp-tid.json",
      package = "hubValidations"
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      bind_model_tasks = FALSE
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      required_vals_only = TRUE
    )
  )
  # Check back-compatibility on older sample specification
  config_tasks <- hubUtils::read_config_file(
    test_path("testdata", "configs", "tasks-samples-old-schema.json")
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26"
    )
  )
  # check that included sample IDs are not generated for older versions
  # of the sample specification
  expect_equal(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      bind_model_tasks = FALSE
    )[[1]],
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = FALSE,
      bind_model_tasks = FALSE
    )[[1]]
  )

  # Check sample IDs unique across multiple modeling task groups
  expect_snapshot(
    expand_model_out_grid(
      hubUtils::read_config_file(
        test_path("testdata", "configs", "tasks-samples-2mt.json")
      ),
      round_id = "2022-12-26",
      include_sample_ids = TRUE
    ) %>%
      dplyr::filter(.data$output_type == "sample")
  )

  # Override config compound_taskid_set
  config_tasks <- hubUtils::read_config_file(
    system.file("config", "tasks-comp-tid.json",
      package = "hubValidations"
    )
  )
  # Create coarser samples
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list(
        c("forecast_date", "target"),
        NULL
      )
    )
  )
  # Create finer samples
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list(
        c("forecast_date", "target", "horizon", "location"),
        NULL
      )
    )
  )
  # Create samples with full compound_taskid_set
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list(
        NULL,
        NULL
      )
    )
  )
})


test_that("expand_model_out_grid output type subsetting works", {
  config_tasks <- hubUtils::read_config_file(
    system.file("config", "tasks-comp-tid.json",
      package = "hubValidations"
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      bind_model_tasks = FALSE,
      output_types = c("pmf", "sample"),
    )
  )

  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      bind_model_tasks = FALSE,
      output_types = "sample",
    )
  )

  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      bind_model_tasks = TRUE,
      output_types = "sample",
    )
  )

  # If a valid output type is provided, invalid ones just ignored
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = FALSE,
      bind_model_tasks = TRUE,
      output_types = c("random", "sample"),
    ),
    error = TRUE
  )

  # If no valid output type provided, errors
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = FALSE,
      bind_model_tasks = FALSE,
      output_types = c("random"),
    ),
    error = TRUE
  )
})

test_that("expand_model_out_grid derived_task_ids ignoring works", {
  config_tasks <- hubUtils::read_config(test_path("testdata", "hub-spl"))

  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-10-22",
      include_sample_ids = FALSE,
      bind_model_tasks = TRUE,
      output_types = "sample",
      derived_task_ids = "target_end_date"
    )
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-10-22",
      include_sample_ids = TRUE,
      bind_model_tasks = TRUE,
      output_types = "sample",
      derived_task_ids = "target_end_date",
      required_vals_only = TRUE
    )
  )

  expect_snapshot(
    expand_model_out_grid(config_tasks,
      round_id = "2022-10-22",
      include_sample_ids = FALSE,
      bind_model_tasks = FALSE,
      output_types = "sample",
      derived_task_ids = c("location", "variant")
    ),
    error = TRUE
  )
})



test_that("expand_model_out_grid errors correctly", {
  # Specifying a round in a hub with multiple rounds
  hub_con <- hubData::connect_hub(
    system.file("testhubs/simple", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "random_round_id"
    ),
    error = TRUE
  )
  expect_snapshot(
    expand_model_out_grid(config_tasks),
    error = TRUE
  )

  hub_con <- hubData::connect_hub(
    system.file("testhubs/flusight", package = "hubUtils")
  )
  config_tasks <- attr(hub_con, "config_tasks")

  expect_snapshot(
    expand_model_out_grid(config_tasks),
    error = TRUE
  )

  # TODO: re-snapshot when error better handled by create_hub_schema
  # when all horizon properties are null
  expect_snapshot(
    str(
      expand_model_out_grid(
        jsonlite::fromJSON(
          test_path(
            "testdata",
            "configs",
            "both_null_tasks_all.json"
          ),
          simplifyVector = TRUE,
          simplifyDataFrame = FALSE
        ),
        round_id = "2023-11-26"
      ) %>%
        dplyr::filter(is.na(horizon))
    ),
    error = TRUE
  )


  config_tasks <- hubUtils::read_config_file(
    system.file("config", "tasks-comp-tid.json",
      package = "hubValidations"
    )
  )
  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list(
        c("forecast_date", "target", "random_var"),
        NULL
      )
    ),
    error = TRUE
  )

  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list(
        c("forecast_date", "target")
      )
    ),
    error = TRUE
  )

  expect_snapshot(
    expand_model_out_grid(
      config_tasks,
      round_id = "2022-12-26",
      include_sample_ids = TRUE,
      compound_taskid_set = list()
    ),
    error = TRUE
  )
})
