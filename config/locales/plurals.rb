# More rules in this file: https://github.com/svenfuchs/i18n/blob/master/test/test_data/locales/plurals.rb
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
{
  pl: {
    i18n: {
      plural: {
        keys: [:one, :few, :other],
        rule: lambda { |n|
          if n == 1
            :one
          else
            if [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
              :few
            else
              :other
            end
          end
        }
      }
    }
  },

  en: {
    i18n: {
      plural: {
        keys: [:one, :other],
        rule: lambda { |n| n == 1 ? :one : :other }
      }
    }
  }
}
