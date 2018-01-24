export const visibilityOptions = {
  PRIVATE: 0,
  INTERNAL: 10,
  PUBLIC: 20,
};

export const visibilityLevelDescriptions = {
  [visibilityOptions.PRIVATE]: '只有项目成员访问才允许访问该项目。必须明确给每一个用户授权访问。',
  [visibilityOptions.INTERNAL]: '任何已登录的用户均可以访问该项目。',
  [visibilityOptions.PUBLIC]: '任何人都可以访问该项目，无论是否登录。',
};
