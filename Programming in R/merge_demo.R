
# simpler merge by default common column
df_left <- data.frame("id" = c(1,2,3), "left_data" = c('a', 'b', 'c'))
df_right <- data.frame("id" = c(1,2,3), "right_data" = c('d', 'e', 'f'))
df_merged1 <- merge(df_left, df_right)


# what happens if there is no common column? 
df_left <- data.frame("left_id" = c(1,2,3), "left_data" = c('a', 'b', 'c'))
df_right <- data.frame("id" = c(1,2,3), "right_data" = c('d', 'e', 'f'))
df_merged2 <- merge(df_left, df_right)


# specify which columns to merge by
df_left <- data.frame("left_id" = c(1,2,3), "left_data" = c('a', 'b', 'c'))
df_right <- data.frame("id" = c(1,2,3), "right_data" = c('d', 'e', 'f'))
df_merged3 <- merge(df_left, df_right, by.x = 'left_id', by.y = 'id')


# Duplicate columns:

df_left <- data.frame("left_id" = c(1,2,3), "data" = c('a', 'b', 'c'))
df_right <- data.frame("id" = c(1,2,3), "data" = c('d', 'e', 'f'))
df_merged4 <- merge(df_left, df_right, by.x = 'left_id', by.y = 'id')


# unequal rows:
df_left <- data.frame("id" = c(1,2,3), "left_data" = c('a', 'b', 'c'))
df_right <- data.frame("id" = c(1,2,3,4), "right_data" = c('d', 'e', 'f', 'g'))
df_merged5 <- merge(df_left, df_right)
df_merged6 <- merge(df_left, df_right, all.y=TRUE)
df_merged7 <- merge(df_left, df_right, all.x=TRUE)
df_merged8 <- merge(df_left, df_right, all.y=FALSE)








